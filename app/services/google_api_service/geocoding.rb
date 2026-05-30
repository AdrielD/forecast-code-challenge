class GoogleApiService::Geocoding
  GEOCODING_API = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze

  class << self
    def fetch(address)
      results = GoogleApiService.get url(address)
      data = results.with_indifferent_access[:results].first

      {
        address: data[:formatted_address],
        zip_code: parse_zip_code(data),
        latitude: parse_latitude(data),
        longitude: parse_longitude(data),
      }
    end

    private

    def url(address)
      key = "key=#{GoogleApiService::API_KEY}"
      address = "address=#{address}"

      URI("#{GEOCODING_API}?#{key}&#{address}")
    end

    def parse_zip_code(data)
      data[:address_components]
        .find { |component| component[:types].include?('postal_code') }[:long_name]
    end
  
    def parse_latitude(data)
      data[:geometry][:location][:lat]
    end
  
    def parse_longitude(data)
      data[:geometry][:location][:lat]
    end
  end
end
