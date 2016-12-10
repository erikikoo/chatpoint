require 'securerandom'

class ChatsController < ApplicationController    
  def index
    chats = current_user.chats
    @existing_chats_users = current_user.existing_chats_users 
    _offline = Subscription.find_by(user_id: current_user.id)
    _offline.update(active: 0) unless _offline.nil?
    get_online
    get_message_no_read    
    inscrito_em
  end

  def create
    @other_user = User.find(params[:other_user])
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end
    redirect_to user_chat_path(current_user, @chat,  :other_user => @other_user.id) 
  end


  def show
    @other_user = UserPerfil.find(params[:other_user])
    @chat = Chat.find_by(id: params[:id])
    Message.where(user_to: params[:user_id], user_id: params[:other_user]).update_all(status: 2)
    @ativo = Subscription.where(chat_id: params[:id], user_id: params[:user_id]).update(active: 1)
    #@chat = Chat.find_by('id = ? AND created_at < ? AND created_at > ?',params[:id],(Time.current),(Time.current - 1.day))
    get_message_no_read
    @message = Message.new
  end

  def converca
    chats = current_user.chats
    @existing_chats_users = current_user.existing_chats_users
  end

  def user_online
    chats = current_user.chats    
    @existing_chats_users = current_user.existing_chats_users
    Subscription.where(user_id: current_user).update(active: false)
    get_online    
  end

  def change_sexo    
    get_message_no_read
    inscrito_em           
   
    session[:option] = params[:option];   
   

    if session[:option].eql?('m')
      session[:genero] = 'Masculino'
      get_user_online(params[:option])
    elsif session[:option].eql?('f')
      session[:genero] = 'Feminino'
      get_user_online(params[:option])        
    elsif session[:option].eql?('i')
      session[:genero] = 'Indefinido'
      get_user_online(params[:option])        
    elsif session[:option].eql?('t') or params[:option].nil?
       get_user_online               
    end
    render partial: 'online'
  end

  def refresh
     get_message_no_read
    inscrito_em
    if session[:option] and session[:option] != 't'      
      get_user_online(session[:option])      
      render :user_online
    else
      get_user_online
      render :user_online  
    end
   
    
  end

  

  def politica
  end

  private
  def find_chat(second_user)
    chats = current_user.chats
    chats.each do |chat|
      chat.subscriptions.each do |s|
        if s.user_id == second_user.id
          return chat
        end
      end
    end
    nil
  end
  def get_message_no_read
    @mesagens = Message.where(user_to: current_user, status: 1).group('user_id').count
  end

  def require_login
    redirect_to new_session_path unless logged_in?
  end

  def get_online    
    @user_online = UserPerfil.where(is_login: true, block: false).where.not(id: current_user)    
  end

  def get_user_online(user='') 
    
    if user.blank?  
      get_online  
      #render :user_online  
    else
      @user_online = UserPerfil.where(sexo: user, is_login: true, block: false).where.not(id: current_user)
      #render partial: 'online'      
    end 
    
    
  end

  def inscrito_em
     @user = InscriptionInTheEstablishment.where(client_id: session[:local_id])
  end

end
