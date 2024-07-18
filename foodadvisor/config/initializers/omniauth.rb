# config/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, GOOGLE_CLIENT_ID = "837679459403-2qr2cgcc5dmcjro7lednp5m1dgqrmqnu.apps.googleusercontent.com", GOOGLE_CLIENT_SECRET = "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"
end

OmniAuth.config.allowed_request_methods = %i[get]
OmniAuth.config.silence_get_warning = true