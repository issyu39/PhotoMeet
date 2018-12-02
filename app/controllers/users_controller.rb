class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :admin_user,     only: :destroy

  def index 
    @users = User.paginate(page:params[:page])

    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params, activated_true: true)
      @title = "Search Result"
    else
      @q = User.ransack(activated_true: true)
    end

    @users = @q.result.paginate(page: params[:page])

  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    require 'open-uri'
    require 'nokogiri'
     
    #スクレイピング対象URL
    if @user.position == "Photographer"
     @url = 'https://search.yahoo.co.jp/image/search?p=nature&ei=UTF-8&fr=top_ga1_sa'
    elsif @user.position == "Model"
     @url = 'https://search.yahoo.co.jp/image/search?p=portrait+girl&ei=UTF-8&fr=top_ga1_sa'
    else
    end

    @html = open(@url) do |f|
      # 対象サイトの文字コード取得
      @charset = f.charset
      # 対象サイトのHTML読み込み
      f.read
    end
     
    @doc = Nokogiri::HTML.parse(@html, nil, @charset)
  
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end


  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        flash[:success]="登録完了しました！"
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url  
  end
  

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  

  private
    
    def set_user
      @user = User.find(params[:id])
    end

    
    def user_params
      params.require(:user).permit(:name, :email, :location, :age, :position, :description, :password, :password_confirmation)
    end
    
    def search_params
      params.require(:q).permit(:name_cont)
    end

     # ログイン済みユーザーかどうか確認
     def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
     # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

  end
     


