class HomeController < ApplicationController

  def index
    @city = "no city sellected"
  end

  def get_meetups
    city = params["city"].gsub(" ","+")
    state = params["state"]
    url_string = "https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&page=20"
    @meetups = HTTParty.get(url_string)
  end

end
