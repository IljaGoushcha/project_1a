class DatesSet

  # Returns dates when to get the weather:
  def self.get_dates
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
