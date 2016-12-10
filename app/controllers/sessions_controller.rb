class SessionsController < ApplicationController

  def new
    if !logged_in?
      @user = User.new
      render 'new'
    end

  end

  def create
    @user = User.find_by(username: login_params[:username])    

    if @user && @user.authenticate(login_params[:password]) 
       session[:user_id] = @user.id
       cookies.signed[:user_id] = @user.id
       if InscriptionInTheEstablishment.find_by(user_perfil_id: @user.user_perfil.id, client_id: session[:local_id])
        #Client.find(session[:local_id]) && 
         update_login(true)       
         redirect_to "/#{session[:local_name]}/chats"
       else          
         @info = "Usuário não possui cadastro neste estabelecimento. " 
         render 'sessions/new'
       end  
    else
      @error = "Usuário e/ou senha inválido"
      render 'sessions/new'
    end
  end

  def destroy
    update_login(false)
    session.destroy
    redirect_to root_path
  end

  def registe_to_establishment
    InscriptionInTheEstablishment.create(user_perfil_id: session[:user_id] , client_id: session[:local_id])
    update_login(true)
    redirect_to "/#{session[:local_name]}/chats"
  end

  private  

  def update_login(u)
    UserPerfil.find(session[:user_id]).update_attributes(is_login: u)
  end
  def login_params
    params.require(:user).permit(:username, :password)
  end
end