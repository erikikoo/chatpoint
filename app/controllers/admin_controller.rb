class AdminController < ApplicationController
	layout 'admin'	
	before_action :logado?
	
	def index
		unless session[:admin_id]
			redirect_to '/admin'
		end
	end

	def new
		@admin = Admin.new
	end

	private

	def logado?
		if session[:admin_id]
			true
		else
			false
		end
	end
end
