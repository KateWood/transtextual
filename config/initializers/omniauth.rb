# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
       provider :developer unless Rails.env.production?
       provider :facebook, ENV["app_id"], ENV["app_secret"]
end