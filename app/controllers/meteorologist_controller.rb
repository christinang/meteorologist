require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    @googleurl = "http://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address_without_spaces
    @parsed_google_data = JSON.parse(open(@googleurl).read)

    @latitude = @parsed_google_data["results"][0]["geometry"]["location"]["lat"]

    @longitude = @parsed_google_data["results"][0]["geometry"]["location"]["lng"]

    @forecasturl = "https://api.forecast.io/forecast/b7c19587d723c111966ca0cb4a141981/" + @latitude.to_s + "," + @longitude.to_s
    @parsed_forecast_data = JSON.parse(open(@forecasturl).read)

    @current_temperature = @parsed_forecast_data["currently"]["temperature"]

    @current_summary = @parsed_forecast_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = @parsed_forecast_data["minutely"]["summary"]

    @summary_of_next_several_hours = @parsed_forecast_data["hourly"]["summary"]

    @summary_of_next_several_days = @parsed_forecast_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
