Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, '698590034136-ihe9mse5trifsnpbf5p4hdd4v95mdpml.apps.googleusercontent.com', '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', {
    scope: 'email profile',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    access_type: 'offline',
    provider_ignores_state: true

    }

    
  end
  