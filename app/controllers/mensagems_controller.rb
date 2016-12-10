class MensagemsController < ApplicationController
  before_action :set_mensagem, only: [:show, :edit, :update, :destroy]
  #before_action :get_all_mensagem, only: [:admin, :update, :destroy]
  # GET /mensagems
  # GET /mensagems.json
  def index
    @mensagems = Mensagem.all
  end

  # GET /mensagems/1
  # GET /mensagems/1.json
  def show
  end

  # GET /mensagems/new
  def new
    @mensagem = Mensagem.new
    if params[:location]
      session[:location] = params[:location]  
    else  
      @mensagems = Mensagem.all.includes('users')
    end
    
    
  end

  # GET /mensagems/1/edit
  def edit
    @action = 'update'
  end

  # POST /mensagems
  # POST /mensagems.json
  def create
    @mensagem = Mensagem.new(mensagem_params)
    
    if session[:admin_id]
      @mensagem.user_id =  session[:admin_id]
      @mensagem.all = true
    elsif session[:location]         
        @mensagem.user_id = current_user.id
        @mensagem.all = false
    end
    if @mensagem.all
      get_all_mensagem('sistema')
    else    
      get_all_mensagem
    end 
    
    if @mensagem.save  
      if session[:location]
        redirect_to "/#{session[:local_name]}/chats"        
      else
        render 'mensagems/admin/admin'      
      end
    else
      render :new         
    end
    
  end

  # PATCH/PUT /mensagems/1
  # PATCH/PUT /mensagems/1.json
  def update
    if @mensagem.all
      get_all_mensagem('sistema')
    else    
      get_all_mensagem
    end  
    
    if @mensagem.update(mensagem_params)
      render 'mensagems/admin/admin'    
    else
       render :edit        
     end
    
  end

  # DELETE /mensagems/1
  # DELETE /mensagems/1.json
  def destroy
    if @mensagem.all
      get_all_mensagem('sistema')
    else    
      get_all_mensagem
    end  
    @mensagem.destroy
    render 'mensagems/admin/admin'    
  end

  def admin
    if params[:sistema]
      session[:sistema] = true
      get_all_mensagem('sistema')
    else
      session[:sistema] = false
      get_all_mensagem
    end  
    @action = 'show'
    render 'mensagems/admin/admin'
  end

  private

    def get_all_mensagem(i='')
      if i.eql?('sistema')
        @mensagens = Mensagem.where(all: true).order(created_at: :desc)
      else
        @mensagens = Mensagem.where(all: false).order(created_at: :desc)
      end  
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_mensagem
      @mensagem = Mensagem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mensagem_params
      params.require(:mensagem).permit(:user_id, :content, :all, :title)
    end
end
