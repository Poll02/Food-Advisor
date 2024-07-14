module SessionsHelper
  def log_in(user, role)
    session[:user_id] = user.id
    session[:role] = role
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    if session[:user_id] && session[:role]
      case session[:role]
      when 'User'
        @current_user ||= Utente.includes(cliente: :user).find_by(id: session[:user_id])
      when 'Ristoratore'
        @current_user ||= Utente.includes(cliente: :ristoratore).find_by(id: session[:user_id])
      when 'Critico'
        @current_user ||= Utente.includes(cliente: { user: :critico }).find_by(id: session[:user_id])
      when 'Admin'
        @current_user ||= Utente.find_by(id: session[:user_id])
      else
        @current_user = nil
      end
    end
  end

  def log_out
    session.delete(:user_id)
    session.delete(:role)
    session.delete(:tmp_password)
    @current_user = nil
  end
end
