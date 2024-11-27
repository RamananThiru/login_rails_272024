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
      render json: {
        message: 'Signup successful',
        user: resource,
        token: request.env['warden-jwt_auth.token']
      }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name)
  end
end
