module SessionsHelper
  def log_in(user, role)
    session[:user_id] = user.id
    session[:role] = role
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    if (user_id = session[:user_id]) && session[:role]
      case session[:role]
      when 'User'
        @current_user ||= Utente.includes(cliente: :user).find_by(id: user_id)
      when 'Ristoratore'
        @current_user ||= Utente.includes(cliente: :ristoratore).find_by(id: user_id)
      when 'Critico'
        @current_user ||= Utente.includes(cliente: { user: :critico }).find_by(id: user_id)
      when 'Admin'
        @current_user ||= Utente.find_by(id: user_id)
      else
        @current_user = nil
      end
    elsif (user_id = cookies.signed[:user_id])
      user = Utente.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user, user_role(user)
        @current_user = user
      end
    end
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    session.delete(:role)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  private

  def user_role(user)
    return 'Admin' if user.admin
    return 'Critico' if user.cliente&.user&.critico
    return 'Ristoratore' if user.cliente&.ristoratore
    return 'User' if user.cliente&.user

    nil
  end
end
