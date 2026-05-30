require 'rails_helper'

RSpec.describe GoogleApiService::Geocoding, type: :service do
  describe '.fetch' do
    it 'returns geocoding data for an address' do
      address = '1600 Amphitheatre Parkway, Mountain View, CA'
      allow(described_class).to receive(:fetch).and_return(
        zip_code: '94043', latitude: 37.422, longitude: -122.084
      )
      result = described_class.fetch(address)
      expect(result).to include(:zip_code, :latitude, :longitude)
    end
  end
end
