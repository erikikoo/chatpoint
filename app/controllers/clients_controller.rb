class ClientsController < ApplicationController
	before_action :get_client, only: [:edit, :update, :destroy]
	before_action :get_all_client, only: [:update, :destroy, :create]
	
	def new
		@client = Client.new
		render 'clients/admin/new'		
	end

	def create
		@client = Client.new(client_params)
		@client.username = @client.cliente
		@client.password = '123456'		
		if @client.save			
			@action = 'show'
			@senha = gerar_senha
			ClientPassword.create(client_id: @client.id, password_digest: @senha)	
			ransack		
			respond_to do |f|
				f.js {render 'clients/admin/create'}
			end
      		
		else
			render :new
		end
	end

	def index
		@senha = ClientPassword.new
		get_last_password	
		
		
	end

	def edit
		@action = 'update';
		render 'clients/admin/edit'
	end

	def update		
		if @client.update(client_params)			
			render action: 'admin/admin'
		elsif	
			render action: 'admin/edit'
		end	
	end

	def destroy		
		@client.destroy
		render action: 'admin/admin'
	end	

	def gerar_senha(size = 10)
		charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
  		@senha = (0...size).map{ charset.to_a[rand(charset.size)] }.join		
	end

	def change_password
		gerar_senha
		ClientPassword.create(client_id: session[:client_id], password_digest: @senha)
		get_last_password
	end



	def show_senha		
		get_last_password
	end

	def new_senha
		@client = Client.new
	end

	def update_senha
		@client =  Client.find(session[:client_id])

		@client.update_attribute('password', client_params[:password] )
		#@client =  Client.find(session[:client_id]).update_attribute('password', client_params[:password])
		if @client
			@sign_in_count = @client.sign_in_count + 1
				@client.update_attribute('sign_in_count', @sign_in_count)
			redirect_to '/comercio/senha'
		else
			render 'new_senha'
		end
	end

	def admin
		ransack		 
			
		@action = 'show'
		render 'clients/admin/admin'
	end

	def select_client
		@action = 'show'		
		if params[:q][:status_present] and params[:q][:status_present].downcase.eql?('ativo')
			params[:q][:status_present] = 1
		elsif params[:q][:status_present] and params[:q][:status_present].downcase.eql?('inativo')
			params[:q][:status_present] = 0
		end	
		  	
		@q = Client.ransack(params[:q])
		@clients = @q.result
		if params[:q][:status_present].blank? and params[:q][:cliente_cont].blank? and params[:q][:cidade_cont].blank? and params[:q][:bairro_cont].blank?
			@teste = nil
		else
			@teste = true
		end
		render 'clients/admin/select_client'
		
	end

	private

	def ransack
		@q = Client.ransack(params[:q])
	  	@clients = @q.result
	end

	def get_all_client
		@clients = Client.all
	end

	def get_client
		@client = Client.find(params[:id])
	end

	
	def get_last_password
		@commerce_password = ClientPassword.where(client_id: session[:client_id]).last
	end

	def client_params
		params.require(:client).permit(:cliente, :cidade, :bairro, :contato, :fone, :status, :url, :password, :logo)
	end
end
