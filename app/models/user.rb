class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  devise :database_authenticatable, 
         :registerable, 
         :recoverable, 
         :rememberable, 
         :validatable,
         :jwt_authenticatable, 
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  # jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null - JWT token invalidation strategy is not set

  validates :password, presence: true, 
                     length: { minimum: 8 }, 
                     format: { with: /\A(?=.*[A-Z])(?=.*\d).*\z/, message: 'must include at least one uppercase letter and one number' }, 
                     confirmation: true,
                     if: :password_required?


  def password_required?
    new_record? || changes[:password].present?
  end
end
