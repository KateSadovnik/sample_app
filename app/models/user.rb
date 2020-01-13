class User < ApplicationRecord
	validates :name, presence: true, length: { maximum: 2 }
	VALID_REGEXP = /\A[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+\z/
	validates :email, presence: true, format: { with: VALID_REGEXP}
end
