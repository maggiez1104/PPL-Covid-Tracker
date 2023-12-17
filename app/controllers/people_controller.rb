require 'date'

class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @people = Person.all
    @search_result = Risk.all

  end

  # GET /people/1 or /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to "/people/new", notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Main function that handles data from user search form
  # Takes in data, performs sql queries and a formula to
  # determine how likely the user is to contract covid

  def search
    puts "----- In Search ------"
    first_name = params[:first_name]
    last_name = params[:last_name]
    contact_first_name = params[:contact_first_name]
    contact_last_name = params[:contact_last_name]
    contact_date = params[:contact_date]
    contact_password = params[:contact_password]

    # sql query into people db to get person info
    # get contacts's date_logged and days_sick

    @password = ActiveRecord::Base.connection.execute("SELECT password FROM people WHERE first_name = '#{contact_first_name}'")

    @date_logged = ActiveRecord::Base.connection.execute("SELECT date_logged FROM people WHERE first_name = '#{contact_first_name}'")

    @days_sick = ActiveRecord::Base.connection.execute("SELECT days_sick FROM people WHERE first_name = '#{contact_first_name}'")

    # Password checking to ensure user info is private
    if @password[0]["password"] != contact_password then
      flash[:error] = 'Incorrect password. Please try again.'
      redirect_to "/search_form"
      return
    end

    # Do calculation: days_sick + (contact_date - date_logged)

    date_logged_obj = Date.parse(@date_logged[0]["date_logged"])
    contact_date_obj = Date.parse(contact_date)

    diff = (contact_date_obj - date_logged_obj).to_i

    total_days_sick = @days_sick[0]["days_sick"].to_i + diff

    # If statements to find contagion risk level:

    if (total_days_sick > 14) or (total_days_sick < 0) then
      risk = "Low"
    elsif (total_days_sick <= 14) and (total_days_sick >= 5) then
      risk = "Medium"
    elsif total_days_sick < 5 then
      risk = "High"
    end

    # Put risk result (low, med, high) into Risk db.

    ActiveRecord::Base.connection.execute("delete from risks;")

    map = {"first_name" => first_name, "last_name" => last_name, \
    "risk" => risk} # or risk?

    newRow = Risk.new(map)

    respond_to do |format|
      if newRow.save
        puts "Success!"
        format.html{redirect_to "/calculator#index" }
      else
        format.html{redirect_to "/"} # Can create error page
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :sick, :days_sick, :date_logged, :password)
    end

    def search_form
    end
end
