class GoogleApiService
  API_KEY = 'AIzaSyCS7gPQecg_kVzEdadsBza0hLW9Tv1QfFE'.freeze

  def self.get(url, cache_key: nil)
    result = Net::HTTP.get(url)
    JSON.parse(result)
  end
end
