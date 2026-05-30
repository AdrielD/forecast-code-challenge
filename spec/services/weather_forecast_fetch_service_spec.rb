require 'rails_helper'

RSpec.describe WeatherForecastFetchService, type: :service do
  let(:address) { '1600 Amphitheatre Parkway, Mountain View, CA' }
  let(:opts) { { units_system: 'metric', days: 3 } }
  let(:geocoding_result) do
    { zip_code: '94043', latitude: 37.422, longitude: -122.084 }
  end
  let(:weather_result) do
    { forecast: [{ day: 'Monday', temp: 20 }] }
  end

  before do
    allow(GoogleApiService::Geocoding).to receive(:fetch).and_return(geocoding_result)
    allow(GoogleApiService::Weather).to receive(:fetch).and_return(weather_result)
    allow(Rails.cache).to receive(:read).and_return(nil)
    allow(Rails.cache).to receive(:write)
  end

  it 'returns weather forecast result' do
    result = described_class.execute(address, opts)
    expect(result).to include(:zip_code, :latitude, :longitude, :forecast)
  end

  it 'caches address to zip code' do
    expect(Rails.cache).to receive(:write).with(/address_/, geocoding_result[:zip_code])
    described_class.execute(address, opts)
  end
end
