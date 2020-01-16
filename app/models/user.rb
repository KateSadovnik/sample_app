class User < ApplicationRecord
	before_save :to_lower_case

	validates :name, presence: true, length: { maximum: 6 }
	VALID_REGEXP = /\A[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+\z/
	validates :email, presence: true, format: { with: VALID_REGEXP}, 
						uniqueness: {case_sensetive: false}
	has_secure_password

	private

	def to_lower_case
		self.email = email.downcase
	end

end
