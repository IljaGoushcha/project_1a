class Meetup

  def self.categories
    {
      1 => "Arts & Cluture", 3 => "Cars & Motorcycle", 5 => "Dancing"#, 6 => "Education & Learning",
      # 8 => "Fashion/Beauty", 9 => "Fitness", 10 => "Food & Drink", 11 => "Games", 17 => "Lifestyle",
      # 18 => "Literature & Writing", 20 => "Movies & Film", 21 => "Music", 23 => "Outdoors & Adventure",
      # 26 => "Pets/Animals", 27 => "Photography"
    }
  end

 # Returns hash of event categories and number ofscheduled events in each category
  def self.get_frequencies_of_meetups(city, state)
    city = city.gsub(" ","+")
    meetups_frequencies = Hash.new
    categories.each do |key, value|
      meetups_frequencies[value.to_sym] = HTTParty.get("https://api.meetup.com/2/open_events?&key=#{ENV["MEETUP_API_KEY"]}&sign=true&photo-host=public&state=#{state}&city=#{city}&country=US&category=#{key.to_i}&page=200")["meta"]["count"]
    end
    return meetups_frequencies.sort_by{|key, value| value}.reverse
  end

end
