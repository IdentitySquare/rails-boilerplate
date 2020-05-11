# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'.freeze
  TEMP_EMAIL_REGEX = /\Achange@me/

  acts_as_paranoid
  has_paper_trail

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, # :timeoutable
         :omniauthable

  validates :first_name, :last_name, presence: true

  validates :email, presence: true, 'valid_email_2/email': {disposable_domain: true}
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update


  def full_name
    "#{first_name} #{last_name}"
  end


  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.email_verified || auth.info.verified_email)
      email = email_is_verified ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          first_name: auth.extra.raw_info.first_name || auth.extra.raw_info.given_name || auth.extra.raw_info.name.split(' ')[0],
          last_name: auth.extra.raw_info.last_name || auth.extra.raw_info.family_name || auth.extra.raw_info.name.split(' ')&[1] || auth.extra.raw_info.name,

          #username: auth.info.nickname || auth.uid,
          email: email,
          password: Devise.friendly_token[0,20]
        )

        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end

  def finished_signup?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

end
