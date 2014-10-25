class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def show_meetups_temperature
    city = params["city"]
    state = params["state"]
    date = Date.today
    dates = DatesSet.get_dates
    @city = city
    @frequencies_of_meetups = Meetup.get_frequencies_of_meetups(city, state)
    @monthly_avg_t = WeatherReport.get_avg_monthly_t(dates, city, state)
    @date = date

  end
end


