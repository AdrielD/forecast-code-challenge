class GoogleApiService::Weather
  CURRENT_WEATHER_API = 'https://weather.googleapis.com/v1/currentConditions:lookup'.freeze
  NEXT_DAYS_WEATHER_API = 'https://weather.googleapis.com/v1/forecast/days:lookup'.freeze

  UNITS_SYSTEMS = ['METRIC', 'IMPERIAL'].freeze

  def self.fetch(latitude, longitude, units_system: nil, days: nil)
    units_system ||= 'METRIC'
    days ||= 7
    raise ApiError::InvalidUnitsSystem.new('Invalid unit') unless UNITS_SYSTEMS.include?(units_system)

    results = GoogleApiService.get current_weather_url(latitude, longitude, units_system)
    data = results.with_indifferent_access

    current = {
      current_date: DateTime.parse(data[:currentTime]).strftime("%Y-%m-%d"),
      current_temperature: data[:temperature][:degrees],
      temperature_unit: data[:temperature][:unit].capitalize,
    }

    results = GoogleApiService.get next_days_weather_url(latitude, longitude, units_system, days)
    data = results.with_indifferent_access[:forecastDays]

    next_days = data.map do |day|
      {
        date: Date.new(day[:displayDate][:year], day[:displayDate][:month], day[:displayDate][:day]),
        maxTemperature: day[:maxTemperature][:degrees],
        minTemperature: day[:minTemperature][:degrees],
      }
    end

    {
      **current,
      next_days:,
    }
  end

  def self.current_weather_url(latitude, longitude, units_system)
    key = "key=#{GoogleApiService::API_KEY}"
    latitude = "location.latitude=#{latitude}"
    longitude = "location.longitude=#{longitude}"
    units_system = "unitsSystem=#{units_system}"

    URI("#{CURRENT_WEATHER_API}?#{key}&#{latitude}&#{longitude}&#{units_system}")
  end

  def self.next_days_weather_url(latitude, longitude, units_system, days)
    key = "key=#{GoogleApiService::API_KEY}"
    latitude = "location.latitude=#{latitude}"
    longitude = "location.longitude=#{longitude}"
    units_system = "unitsSystem=#{units_system}"
    days = "days=#{days}"

    URI("#{NEXT_DAYS_WEATHER_API}?#{key}&#{latitude}&#{longitude}&#{units_system}&#{days}")
  end
end
