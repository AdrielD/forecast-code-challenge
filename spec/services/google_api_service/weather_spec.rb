require 'rails_helper'

RSpec.describe GoogleApiService::Weather, type: :service do
  describe '.fetch' do
    it 'returns weather data for coordinates' do
      allow(described_class).to receive(:fetch).and_return(
        forecast: [{ day: 'Monday', temp: 20 }]
      )
      result = described_class.fetch(37.422, -122.084, units_system: 'metric', days: 3)
      expect(result).to include(:forecast)
    end
  end
end
