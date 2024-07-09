module ApplicationHelper
    def masked_password(password)
        return "Nessuna password" if password.nil?
        "••••••••"
    end
end
