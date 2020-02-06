class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token

	has_many :microposts, dependent: :destroy

	before_save :to_lower_case
	before_create :create_activation_digest

	validates :name, presence: true, length: { maximum: 100 }
	VALID_REGEXP = /\A[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+\z/
	validates :email, presence: true, format: { with: VALID_REGEXP}, 
						uniqueness: {case_sensetive: false}
	has_secure_password

# Returns the hash digest of the given string.
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end


# Returns a random token.
	def self.new_token
		SecureRandom.urlsafe_base64
	end

# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token matches the digest.
	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	def send_activation_email
	UserMailer.account_activation(self).deliver_now
	end

	def activate
	update_attribute(:activated, true)
	update_attribute(:activated_at, Time.zone.now)
	end

	# Sets the password reset attributes.
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends password reset email.
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	def feed
		Micropost.where("user_id = ?", id)
	end

	private

	def to_lower_case
		self.email = email.downcase
	end

def create_activation_digest
	self.activation_token = User.new_token
	self.activation_digest = User.digest(activation_token)
end


end
