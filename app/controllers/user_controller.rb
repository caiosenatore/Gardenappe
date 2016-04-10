class UserController < ApplicationController

  before_action :authorized?, only: [:index,
                                     :myphoto,
                                     :mypassword,
                                     :myinfo,
                                     :update,
                                     :updatecurrentuser,
                                     :show,
                                     :list,
                                     :singlecountusers]

  def login
    render layout: 'backstage', :template => 'user/backstage/_pages/login'
  end

  def index
    render layout: 'backstage', :template => 'user/backstage/_pages/index'
  end

  def myinformation
    @user = current_user

    render layout: 'backstage', :template => 'user/backstage/_pages/myinformation'
  end

  def logout
    disconnect
    redirect_to login_user_index_path # Back to login page
  end

  def thankyou
    @user = User.find(user_id)
    @token_url_auth = generate_email_token_url @user

    render layout: 'backstage', :template => 'user/backstage/_pages/thankyou'
  end

  def confirmemail
    @user = User.find(user_id)
    @email_confirmed = false

    if !@user.nil? && !@user.email_token.nil? && @user.email_token == tokenize
      @user.email_token_valid = true
      @user.save!
      @email_confirmed = true
    end

    render layout: 'backstage', :template => 'user/backstage/_pages/confirmemail'
  end

  def list
    @page = 6
    @search = search
    @users = User.list_all page, @page, @search

    render layout: 'backstage', :template => 'user/backstage/_pages/list'
  end

  def myphoto
    render layout: 'backstage', :template => 'user/backstage/_pages/myphoto'
  end

  def authenticate
    @authenticated = false
    @user = User.new(user_param) # Load user
    # Follow the roles, email ok, activated ok, email token ok. + password
    user_authenticated = User.where(:email => @user.email, :activated => true, :email_token_valid => true).first.try(:authenticate, @user.password) # Authenticate user with password

    if user_authenticated != false && !user_authenticated.nil? # If correct
      session[:current_user] = user_authenticated.id # Authenticate!
      @authenticated = true # go go go
    else
      session[:current_user] = nil
    end

    render json: {data: current_user, validations: nil, message: (@authenticated ? nil : 'E-mail and password are incorrect')}
  end

  def create
    @user = User.new(user_param)
    @user.generate_email_auth_key
    @user.is_an_administrator = false
    @user.email_token_valid = false

    if @user.valid?
      @user.save!
      send_email_for_email_authentication @user # Send email
    end

    render json: {data: nil, validations: @user.errors.messages, thankyouurl: user_thankyou_path(@user.id)}
  end

  def update
    render json: {data: nil}
  end

  def show
    @user = User.find(id)
  end

  def updatecurrentuser
    redirect_to_login = false
    @user = current_user

    # Check if is a e-mail changing at first
    if !user_param[:email].nil? && @user.email_changing?(user_param[:email])
      send_email_for_email_authentication @user # Send email
      disconnect
      redirect_to_login = true # Disconnect
    end

    @user.update_attributes user_param # Update attributes
    @user.photo.reprocess! if @user.cropping? # Crop image if is an upload

    # Check if is a password changing to logout
    if @user.password_changing? # Password changing?
      disconnect
      redirect_to_login = true # Disconnect
    end

    render json: {data: nil, validations: @user.errors.messages, redirect_to_login: redirect_to_login}
  end

  def user_param
    params.require(:user).permit!
  end

  def user_id
    params.require(:user_id)
  end

  def id
    params.require(:id)
  end

  def page
    if params[:page].nil?
      1
    else
      params[:page]
    end
  end

  def search
    params[:search]
  end

  def tokenize
    params.require(:tokenize)
  end

  # Singles
  def singlecountusers
    render json: {single: User.count_activated}
  end

  private
  def generate_email_token_url user
    user_confirmemail_path + "?tokenize=" + user.email_token
  end

  def send_email_for_email_authentication user
    UserMailer.email_authentication(user, generate_email_token_url(user)).deliver_now
  end

  def disconnect
    session[:current_user] = nil # Destoy user logged
  end
end