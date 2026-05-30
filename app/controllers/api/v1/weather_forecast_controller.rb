class Api::V1::WeatherForecastController < ApiController
  def index
    result = WeatherForecastFetchService.execute(
      index_params[:address],
      units_system: index_params[:units_system],
      days: index_params[:days],
    )

    render json: result,status: :ok
  end

  private

  def index_params
    params.permit(:address, :units_system, :days)
  end
end
