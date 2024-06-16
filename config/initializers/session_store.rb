# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: '_tubereviews_session', expire_after: 30.minutes
