class CalculatorController < ApplicationController
  def index
      @search_result = Risk.all
      @source = params[:source]
  end
end
