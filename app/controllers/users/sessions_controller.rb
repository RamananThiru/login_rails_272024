class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Verify the correct token before a jwt token is created or destroyed
  before_action :authenticate_user_from_token!, only: [:create, :destroy]

  def create
    user = User.find_for_database_authentication(email: params.dig(:user, :email))

    if user && user.valid_password?( params.dig(:user,:password))
      sign_in(user)  # Sign the user in
      render json: {
        message: 'Logged in successfully',
        user: user,
        token: request.env['warden-jwt_auth.token']  # JWT token
      }, status: :ok
    else
      render json: { errors: 'Invalid/Incorrect credentials' }, status: :unauthorized
    end
  end


  private

  def authenticate_user_from_token!    
    unless user_signed_in?
      render json: { errors: 'Invalid/Expired token' }, status: :unauthorized
    end
  end

  
  def respond_to_on_destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end