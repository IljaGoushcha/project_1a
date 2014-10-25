class CityMeetupsTController < ApplicationController

  def show_city_meetups_t
    @city = params["city"]
    @state = params["state"]
    @date = Date.today
    dates = DatesSet.get_dates
    @frequencies_of_meetups = Meetup.get_frequencies_of_meetups(@city, @state)
    @monthly_avg_t = WeatherReport.get_avg_monthly_t(dates, @city, @state)
  end

end
