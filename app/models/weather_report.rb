class WeatherReport

  # Returns average temperature accross the month prior to today
  def self.get_avg_monthly_t(dates, city, state)
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

  # Returns average temperatue for a given date in a given city
  def self.get_single_day_avg_t(date, city, state)
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
      binding.pry
    return single_day_avg_t = single_day_ts_sum/s
  end

end
