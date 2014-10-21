class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def generate_categories

    city = params["city"].gsub(" ","+")
    state = params["state"]
    meetups = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&page=50")["results"]
    @group_ids = meetups.map do |meetup|
      meetup["group"]["id"]
    end
    # WORKS UP TO HERE
    @first_group_id = @group_ids[0]
    @category = HTTParty.get("https://api.meetup.com/2/groups?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&group_id=#{"@first_group_id"}&page=20")
    # binding.pry
    # @categories = @group_ids.map do |group_id|
    #   group_id + 1000000000000
    #   HTTParty.get("https://api.meetup.com/2/groups?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&group_id=#{"group_id"}&page=1")["results"][0]["category"]
    # end

    # this should work
    # HTTParty.get("https://api.meetup.com/2/groups?&key=426c7a3d714f70521072414643787210&sign=true&photo-host=public&group_id=7183412&page=1")["results"][0]["category"]
  end
end
