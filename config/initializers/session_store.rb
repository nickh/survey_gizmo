# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_survey_gizmo_session',
  :secret      => 'd0daa381f8e7ad5f8786f6a5212a5ba7568e6503eb07b0128e8095c054294cef8f5fed999b45bcba5ce28c565dc21a043952bb4aa75ab9f0987ebb4075964ab4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
