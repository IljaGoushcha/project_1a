class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def get_meetups
    city = params["city"].gsub(" ","+")
    state = params["state"]

    @categories = {
      1 => "Arts & Cluture", 3 => "Cars & Motorcycle", 5 => "Dancing"
      # 6 => "Education & Learning",
      # 8 => "Fashion/Beauty", 9 => "Fitness", 10 => "Food & Drink", 11 => "Games", 17 => "Lifestyle",
      # 18 => "Literature & Writing", 20 => "Movies & Film", 21 => "Music", 23 => "Outdoors & Adventure",
      # 26 => "Pets/Animals", 27 => "Photography"
    }

    @results = Hash.new
    @categories.each do |key, value|
      @results[value.to_sym] = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&category=#{key.to_i}&page=100")["meta"]["count"]
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

end
