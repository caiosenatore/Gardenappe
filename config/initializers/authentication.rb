# Authentication methods
def current_user
  User.find session[:current_user] unless session[:current_user].nil?
end

def user_authenticated?
  if session[:current_user].nil?
    false
  else
    true
  end
end

def user_authenticated_is_admin
  if user_authenticated? && current_user.is_an_administrator
    true
  else
    false
  end
end

def authorized?
  if !user_authenticated?
    redirect_to login_user_index_path
  end
end

def authorized_admin?
  authorized?
  redirect_to login_user_index_path if !user_authenticated_is_admin
end