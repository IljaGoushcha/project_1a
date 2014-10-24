class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end



  def show_meetups_temperature
    city = params["city"]
    state = params["state"]
    date = Date.today
    dates = get_dates
    @city = city
    @frequencies_of_meetups = get_frequencies_of_meetups(city, state)
    @monthly_avg_t = get_avg_monthly_t(dates, city, state)
    @date = date

  end

  # Returns hash of event categories and number ofscheduled events in each category
  def get_frequencies_of_meetups(city, state)
    city = city.gsub(" ","+")
    categories = {
      1 => "Arts & Cluture", 3 => "Cars & Motorcycle", 5 => "Dancing", 6 => "Education & Learning",
      8 => "Fashion/Beauty", 9 => "Fitness", 10 => "Food & Drink", 11 => "Games", 17 => "Lifestyle",
      18 => "Literature & Writing", 20 => "Movies & Film", 21 => "Music", 23 => "Outdoors & Adventure",
      26 => "Pets/Animals", 27 => "Photography"
    }
    meetups_frequencies = Hash.new
    categories.each do |key, value|
      meetups_frequencies[value.to_sym] = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&category=#{key.to_i}&page=200")["meta"]["count"]
    end
    return meetups_frequencies.sort_by{|key, value| value}.reverse
  end

  # Returns average temperatue for a given date in a given city
  def get_single_day_avg_t(date, city, state)
    city = city.gsub(" ","_")
    single_day_weather = HTTParty.get("http://api.wunderground.com/api/#{ENV["WUNDERGROUND_API_KEY"]}/history_#{date}/q/#{state}/#{city}.json")
    single_day_ts = Array.new
    single_day_weather["history"]["observations"].map do |single_day_observation|
      single_day_ts << single_day_observation["tempm"].to_f
    end
    single_day_ts_sum = 0
    single_day_ts.map do |single_day_t|
      single_day_ts_sum += single_day_t
    end
      single_day_ts.size != 0 ? s = single_day_ts.size : s = 12
    return single_day_avg_t = single_day_ts_sum/s
  end

  # Returns average temperature accross the month prior to today <h5> <%=@weather["history"]["observations"]%> </h5>
  def get_avg_monthly_t(dates, city, state)
    month_ts = Array.new
    dates.map do |date|
      month_ts << get_single_day_avg_t(date, city, state)
    end

    month_ts_sum = 0
    month_ts.map do |single_day_avg_t|
      month_ts_sum += single_day_avg_t
    end
    avg_monthly_t = (month_ts_sum/month_ts.size).round(2)
    return avg_monthly_t
  end

  # Returns dates when to get the weather:
  def get_dates
    dates = Array.new
    temp = Array.new(7)
    todays_date = Date.today
    temp.map.with_index do |date, i|
      d = todays_date - 4*i
      year = d.year.to_s
      d.month<10 ? month="0"+d.month.to_s : month=d.month.to_s
      d.day<10 ? day="0"+d.day.to_s : day=d.day.to_s
      dates << year+month+day
    end
    return dates
  end

end


