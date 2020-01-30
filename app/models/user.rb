class User < ApplicationRecord
	attr_accessor :remember_token

	before_save :to_lower_case

	validates :name, presence: true, length: { maximum: 20 }
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
	def authenticated?(remember_token)
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	private

	def to_lower_case
		self.email = email.downcase
	end




end
