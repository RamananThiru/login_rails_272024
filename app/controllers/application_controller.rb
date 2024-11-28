class ApplicationController < ActionController::API


  # Application level unexpected error Handler with consistent error response format 
  rescue_from StandardError do |exception|
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: { errors: "Something went wrong, please contact support." }, status: :internal_server_error
  end
end
