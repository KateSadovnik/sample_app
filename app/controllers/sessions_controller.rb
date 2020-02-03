class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.activated?
				log_in(user)
				remember(user)
				redirect_to user
				else
					flash[:warning] = 'ACTIVATE!!!!!' # Not quite right!
					redirect_to signup_url
			end
		else
			flash[:danger] = 'Invalid email/password combination' # Not quite right!
			render 'new'
  	end
  end

def destroy
	log_out
	flash[:danger] = 'Logged !!!'
	redirect_to root_url	
end
	end
