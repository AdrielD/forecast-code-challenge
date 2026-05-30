require 'rails_helper'

RSpec.describe Api::V1::WeatherForecastController, type: :controller do
  describe 'GET #index' do
    let(:address) { '1600 Amphitheatre Parkway, Mountain View, CA' }
    let(:opts) { { units_system: 'metric', days: 3 } }
    let(:forecast_result) do
      {
        zip_code: '94043',
        latitude: 37.422,
        longitude: -122.084,
        current_temperature: 22.5
      }
    end

    before do
      allow(WeatherForecastFetchService).to receive(:execute)
        .and_return(forecast_result)
    end

    it 'returns http success' do
      get :index, params: { address: address }
      expect(response).to have_http_status(:success)
    end

    it 'returns the forecast as JSON' do
      get :index, params: { address: address }
      json = JSON.parse(response.body)
      expect(json).to include('zip_code', 'latitude', 'longitude', 'current_temperature')
    end
  end
end
