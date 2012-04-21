class ApiController < ApplicationController
  def login
    puts "State:#{params[:state]}"
    puts "Code:#{params[:code]}"

  end
end