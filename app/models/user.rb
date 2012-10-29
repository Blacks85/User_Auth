# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  username           :string(255)
#

class User < ActiveRecord::Base
	
	require 'digest/sha1'
	
	before_save :encrypt_password
	after_save :clear_password
	
	attr_accessible :username, :email, :password, :password_confirmation
	attr_accessor :password
	
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$/i
	
	validates :username, 	:presence => true, 
							:length => { :in => 3..20 }
	validates :email, 	:presence => true, 
						:uniqueness => true, 
						:format => EMAIL_REGEX
	validates :password, 	:confirmation => true, 
							:length => { :in => 6..20 }
							
	def encrypt_password
		if password.present?
			salt = Digest::SHA1.hexdigest(email + Time.now.to_s)
			encrypted_password = Digest::SHA1.hexdigest(password + salt)
		end
	end

	def clear_password
		password = nil
	end
	
	def self.authenticate(username_or_email = "", login_password = "")
		if  EMAIL_REGEX.match(username_or_email)    
			user = User.find_by_email(username_or_email)
		else
			user = User.find_by_username(username_or_email)
		end
	
		if user && user.match_password(login_password)
			return user
		else
			return false
		end
	end
	
	def match_password(login_password = "")
		encrypted_password == Digest::SHA1.hexdigest(login_password + salt)
	end
end
