class ApiController < ActionController::API
  rescue_from StandardError do |e|
    render json: { error: 'Something went very VERY bad...' }, status: :internal_server_error
  end
  rescue_from ApiError::BadlyFormatedAddress do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
  rescue_from ApiError::InvalidUnitsSystem do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
