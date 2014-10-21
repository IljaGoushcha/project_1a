class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def get_meetups
    city1 = params["city"].gsub(" ","+")
    city2 = params["city"].gsub(" ","_")
    state = params["state"]
    # FIRST, GET MEET_UPS
    @categories = {
      1 => "Arts & Cluture", 3 => "Cars & Motorcycle", 5 => "Dancing"
      # 6 => "Education & Learning",
      # 8 => "Fashion/Beauty", 9 => "Fitness", 10 => "Food & Drink", 11 => "Games", 17 => "Lifestyle",
      # 18 => "Literature & Writing", 20 => "Movies & Film", 21 => "Music", 23 => "Outdoors & Adventure",
      # 26 => "Pets/Animals", 27 => "Photography"
    }

    @meetup_frequencies = Hash.new
    @categories.each do |key, value|
      @meetup_frequencies[value.to_sym] = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city1}&country=US&category=#{key.to_i}&page=100")["meta"]["count"]
    end

    # GET DATES when to get the weather:
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

    # NOW GET WEATHER: this should work:weather["history"]["observations"][0]["tempm"]
    @date = get_dates[0]
    @weather = HTTParty.get("http://api.wunderground.com/api/#{ENV["WUNDERGROUND_API_KEY"]}/history_#{@date}/q/#{state}/#{city2}.json")
    # @weather2 = weather["history"]["observations"][0]["tempm"]
    # @avg_t = 0
    @all_ts = Array.new
    @weather["history"]["observations"].map do |observation|
      @all_ts << observation["tempm"]
    end

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

