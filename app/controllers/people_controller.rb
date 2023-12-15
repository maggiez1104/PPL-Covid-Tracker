require 'date'
class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @people = Person.all
    @search_result = Risk.all

    puts "---- here is index method search result ------"

    puts @search_result
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
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    puts "----- In Search ------"
    first_name = params[:first_name]
    last_name = params[:last_name]
    contact_first_name = params[:contact_first_name]
    contact_last_name = params[:contact_last_name]
    contact_date = params[:contact_date]

    # sql query into people db to get person info
    # get person's date_logged and days_sick

    # select date_logged, days_sick from people where first_name = first_name;

    @date_logged = ActiveRecord::Base.connection.execute("SELECT date_logged FROM people WHERE first_name = '#{contact_first_name}'")

    @days_sick = ActiveRecord::Base.connection.execute("SELECT days_sick FROM people WHERE first_name = '#{contact_first_name}'")
    puts "-------- here is days logged and sick --------"
    puts @date_logged[0]["date_logged"]
    puts @days_sick[0]["days_sick"]
    # Do calculation: days_sick + (contact_date - date_logged)
      # edge case: what if contact_date - date_logged is in a different month

    #TODO: figure out how to subtract days from date object


    date_logged_obj = Date.parse(@date_logged[0]["date_logged"])
    contact_date_obj = Date.parse(contact_date)

    diff = (date_logged_obj - contact_date_obj).to_i

    total_days_sick = @days_sick[0]["days_sick"].to_i + diff

    puts "----- here is total days sick #{total_days_sick}-------"


    #total_days_sick = @days_sick + (contact_date - @date_logged)
    # testing
    #total_days_sick = 3

    # If statements:

    if total_days_sick > 7 then
      risk = "Low"
    elsif (total_days_sick <= 7) and (total_days_sick >= 3) then
      risk = "Medium"
    elsif total_days_sick < 3 then
      risk = "High"
    end

    # Put risk result (low, med, high) into Risk db.

    puts "---- here is risk -----"
    puts risk

    ActiveRecord::Base.connection.execute("delete from risks;")

    map = {"first_name" => first_name, "last_name" => last_name, \
    "risk" => risk} # or risk?

    newRow = Risk.new(map)

    respond_to do |format|
      if newRow.save
        puts "Success!"
        #format.html{redirect_to "articles#index"}
        format.html{redirect_to "/people#index"}
      else
        format.html{redirect_to "/"} # Can create error page
      end
    end
    # display on home page: Your risk level is: (get Risk db risk var)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :sick, :days_sick, :date_logged)
    end

    def search_form
    end


    def searchOld
      contact_first_name = params[:contact_first_name]
      contact_last_name = params[:contact_last_name]
      contact_date = params[:contact_date]

      # Query the database to find the person based on the name
      @contact_person = Person.where(first_name: contact_first_name, last_name: contact_last_name)

      if @contact_person

      else
        # Handle when the person is not found
        flash[:alert] = "Person not found."
        redirect_to root_path
      end
    end
end
