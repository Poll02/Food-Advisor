module SessionsHelper
  def log_in(user, role)
    session[:user_id] = user.id
    session[:user_role] = role
  end

  def current_user
    @current_user ||= find_current_user_by_role
  end

  def current_user_role
    session[:user_role]
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    session.delete(:user_role)
    @current_user = nil
  end

  private

  def find_current_user_by_role
    if session[:user_role] == 'User'
      User.find_by(id: session[:user_id])
    elsif session[:user_role] == 'Ristoratore'
      Ristoratori.find_by(id: session[:user_id])
    else
      nil
    end
  end
end
