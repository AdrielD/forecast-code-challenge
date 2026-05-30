require 'net/http'

class WeatherForecastFetchService
  class << self
    def execute(address, opts)
      raise ApiError::BadlyFormatedAddress.new('Please provide a valid address') if address.blank?

      # Since we are using Google's api, we can send any address.
      # To avoid another call to the geocoding api just to rediscover the zip code
      # over and over, I'm caching each address string (even a zip code) to the
      # corresponding zip code we'll eventually find. 
      cached_zip_code = zip_code_from_address_cache(address)

      if cached_zip_code
        Rails.logger.info("Found zip_code in cache, address: #{address}, zip_code: #{cached_zip_code}")
        cached = from_cache(cached_zip_code)
        return cached unless cached.nil?
      end

      geocoding_result = GoogleApiService::Geocoding.fetch(address)

      cache_address_to_zip_code(address, geocoding_result[:zip_code])

      # Checks the cache now that we have the zip code
      cached = from_cache(geocoding_result[:zip_code])
      return cached unless cached.nil?

      weather_result = GoogleApiService::Weather.fetch(
        geocoding_result[:latitude],
        geocoding_result[:longitude],
        units_system: opts[:units_system],
        days: opts[:days],

        # Here I realized we may need to invalidate the cache if the user 
        # change options, like asking a large forecast range or change units...
        # I'll just leave this as a shameless TODO, we get the idea! :)
      )

      result = {
        **geocoding_result,
        **weather_result,
        cached: false,
        expires_at: nil
      }

      save_to_cache(result[:zip_code], result)
    end

    private

    def zip_code_from_address_cache(address)
      key = "address_#{address.parameterize.underscore}"
      Rails.cache.read(key)
    end

    def cache_address_to_zip_code(address, zip_code)
      key = "address_#{address.parameterize.underscore}"
      Rails.cache.write(key, zip_code)
    end

    def from_cache(key)
      cached = Rails.cache.read(key)

      unless cached.nil?
        Rails.logger.info("Found in cache, key: #{key}")

        return cached.merge(cached: true)
      end

      nil
    end

    def save_to_cache(key, value)
      expires_at = Time.now + 30.minutes
      Rails.cache.write(key, value.merge(expires_at:))
      value
    end
  end
end
