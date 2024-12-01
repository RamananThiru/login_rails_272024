class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # Reuse Devise based api functionalities
  # Override internal Devise::RegistrationsController methods to aceept custom params

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: registration_success_response(resource), status: :ok
    else
      render json: registration_error_response(resource), status: :unprocessable_entity
    end
  end

  def registration_success_response(resource)
    {
      message: 'Signup successful',
      token: request.env['warden-jwt_auth.token']
    }
  end

  # Custom Validation Error Response for consistent error respons format
  def registration_error_response(resource)
    formatted_errors = {}
    resource.errors.each do |error|
      formatted_errors[error.attribute] = error.message
    end
    { errors: formatted_errors, message: 'Registration Failed for the user' }
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
  end
end
