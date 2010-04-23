# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_linguist_session',
  :secret      => 'b21533628b90de210b3e55b7425dd348bd19ea7f8b3550917658bfa4d82e16b51e91f84d74bd19681b4fca6129170390068c9e09a779ad7fa1ab89b9aaef1afa'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
