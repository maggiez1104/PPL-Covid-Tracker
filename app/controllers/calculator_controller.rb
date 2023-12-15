class CalculatorController < ApplicationController
  def index
    @search_result = Risk.all
  end
end
