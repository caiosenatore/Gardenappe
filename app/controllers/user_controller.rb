class UserController < ApplicationController
  def login

  end

  def thankyou
    @user = User.find(user_id)
    @token_url_auth = "http://" + request.host + ":" + request.port.to_s + "/user/" + @user.id.to_s + "/confirmemail?tokenize=" + @user.email_token
  end

  def confirmemail
    @user = User.find(user_id)
    @email_token = tokenize
    @email_confirmed = false

    if !@user.nil? && !@user.email_token.nil? && @user.email_token == @email_token
      @user.email_token = nil
      @user.save!
      @email_confirmed = true
    end
  end

  def show

  end

  def create
    @user = User.new(user_param)
    @user.email_token = SecureRandom.hex(50)

    if @user.valid?
      @user.save!
    end

    render json: {data: @user.as_json, validations: @user.errors.messages, redirect_url: (@user.id.nil? ? nil : user_thankyou_path(@user.id).to_s) }
  end

  def user_param
    params.require(:user).permit!
  end

  def user_id
    params.require(:user_id)
  end

  def tokenize
    params.require(:tokenize)
  end
end