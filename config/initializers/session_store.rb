# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_prototype_session',
  :secret      => 'ae3b33d0fd24e90e0a513ba2f3282ed3e139e6fca9c5b09f585a1c99bd89115c11361fafd1c8869d8c61001951392fb95bb77a9e7e610f6a789faabd2a3c66c3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
