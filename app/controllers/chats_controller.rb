require 'securerandom'

class ChatsController < ApplicationController  
  #before_action :get_message_no_read, only: [:change_sexo]
  #caches_action :refresh_user_and_msn

  #before_action :get_message_no_read, only: [:index, :user_online]
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
    params[:option].nil? ? session[:option] = nil : session[:option] = params[:option];   
    
      if session[:option] == 'm'
        @genero = 'Masculino'
        get_user_online(params[:option])
        render partial: 'online'
      elsif session[:option] == 'f'
        @genero = 'Feminino'
        get_user_online(params[:option])
        render partial: 'online'
      elsif session[:option] == 'i'
        @genero = 'Indefinido'
        get_user_online(params[:option])
        render partial: 'online'
      elsif session[:option] == 't'        
         get_user_online
         render partial: 'online'
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
    @mesagens = Message.where(user_to: current_user, status: true).group('user_id').count
  end

  def require_login
    redirect_to new_session_path unless logged_in?
  end

  def get_online    
    @user_online = UserPerfil.where(is_login: true, block: false).where.not(id: current_user)    
  end

  def get_user_online(user='') 
    get_message_no_read
    if user.blank?      
      get_message_no_read
      get_online  
    else
      @user_online = UserPerfil.where(sexo: user, is_login: true, block: false).where.not(id: current_user)
    end 
    #render :user_online
    #render partial: 'online'
  end

  def inscrito_em
     @user = InscriptionInTheEstablishment.where(client_id: session[:local_id])
  end

end
