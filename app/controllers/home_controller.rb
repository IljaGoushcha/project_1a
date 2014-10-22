class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def show_meetups_temperature
    city = params["city"]
    state = params["state"]
    date = Date.today
    @city = city
    @meetups_frequencies = get_frequencies_of_meetups(city, state)
    @all_ts = get_avg_temp(city, state)
    @single_day_avg_t = get_single_day_avg_t(date, city, state)
    @date = date
  end

  # Returns hash of event categories and number ofscheduled events in each category
  def get_frequencies_of_meetups(city, state)
    city = city.gsub(" ","+")


    categories = {
      1 => "Arts & Cluture", 3 => "Cars & Motorcycle", 5 => "Dancing" #, 6 => "Education & Learning",
      # 8 => "Fashion/Beauty", 9 => "Fitness", 10 => "Food & Drink", 11 => "Games", 17 => "Lifestyle",
      # 18 => "Literature & Writing", 20 => "Movies & Film", 21 => "Music", 23 => "Outdoors & Adventure",
      # 26 => "Pets/Animals", 27 => "Photography"
    }

    meetups_frequencies = Hash.new
    categories.each do |key, value|
      meetups_frequencies[value.to_sym] = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&category=#{key.to_i}&page=100")["meta"]["count"]
    end
    return meetups_frequencies
  end

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
    return single_day_avg_t = single_day_ts_sum/single_day_ts.size
  end

  # Returns average temperature accross the month prior to today <h5> <%=@weather["history"]["observations"]%> </h5>
  def get_avg_temp(city, state)
    dates = get_dates
    city = city.gsub(" ","_")
    month_ts = Array.new
    dates.map do |date|

      single_day_weather = HTTParty.get("http://api.wunderground.com/api/#{ENV["WUNDERGROUND_API_KEY"]}/history_#{date}/q/#{state}/#{city}.json")
      single_day_ts = Array.new
      single_day_weather["history"]["observations"].map do |single_day_observation|
        single_day_ts << single_day_observation["tempm"].to_f
      end

      single_day_ts_sum = 0
      single_day_ts.map do |single_day_t|
        single_day_ts_sum += single_day_t
      end
      single_day_avg = single_day_ts_sum/single_day_ts.size

      month_ts << single_day_avg
    end

    month_ts_sum = 0
    month_ts.map do |single_day_t|
      month_ts_sum += single_day_t
    end
    @month_avg = month_ts_sum/month_ts.size

    return @month_avg
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

    # retiring this request
    # meetups = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&page=5 0")["results"]
    # @group_ids = meetups.map do |meetup|
    #   meetup["group"]["id"]
    # end

    # WORKS UP TO HERE
    # @first_group_id = @group_ids[0]
    # @group = HTTParty.get("https://api.meetup.com/2/groups?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&group_id=#{@first_group_id}&page=20")
    # @category = @group["results"][0]["category"]

    # Retired due to request limits at MeetUp
    # @categories = @group_ids.map do |group_id|
    #   HTTParty.get("https://api.meetup.com/2/groups?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&group_id=#{group_id}&page=20")["results"][0]["category"]
    #   sleep 0.001
    #   # HTTParty.get("https://api.meetup.com/2/groups?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&group_id=6589142    &page=20")["results"][0]["category"]
    # end

    # this should work
    # HTTParty.get("https://api.meetup.com/2/groups?&key=426c7a3d714f70521072414643787210&sign=true&photo-host=public&group_id=7183412&page=1")["results"][0]["category"]
    # HTTParty.get("https://api.meetup.com/2/groups?&key=#{MEETUP_API_KEY}&sign=true&photo-host=public&group_id=6589142&page=20")["results"][0]["category"]

