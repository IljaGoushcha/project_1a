class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def generate_categories

    city = params["city"].gsub(" ","+")
    state = params["state"]
    url_string = "https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&page=100"
    meetups = HTTParty.get(url_string)["results"]
    @group_ids = meetups.map do |meetup|
      meetup["group"]["id"]
    end
    # WORKS UP TO HERE

    # @categories = group_ids.map do |group_id|
    #   HTTParty.get("https://api.meetup.com/2/groups?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&group_id=#{group_id}&page=5")["results"]
    # end
    # HTTParty.get(C
  end
end
