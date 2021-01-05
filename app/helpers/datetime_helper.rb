module DatetimeHelper
  def display_date_for(datetime, attrs = {})
    format = attrs[:without_year] ? '%A %d %B' : '%A %d %B %Y'
    l(datetime, format: format)
  end
end
