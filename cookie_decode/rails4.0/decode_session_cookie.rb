# decode_session_cookie.rb
# ------------------------
# The purpose of this script is to show that if I have the secret_key_base
# and a cookie to an active Rails session, I can decrypt it and gain access
# to key information about the user's session.

require 'rubygems'
require 'cgi'
require 'active_support'
require 'action_controller'

def decrypt_session_cookie(cookie, key)
  cookie = CGI::unescape(cookie)
  
  # Default values for Rails 4 apps
  key_iter_num = 1000
  key_size     = 64
  salt         = "encrypted cookie"         
  signed_salt  = "signed encrypted cookie"  

  key_generator = ActiveSupport::KeyGenerator.new(key, iterations: key_iter_num)
  secret = key_generator.generate_key(salt)
  sign_secret = key_generator.generate_key(signed_salt)

  encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: ActiveSupport::MessageEncryptor::NullSerializer)
  puts Marshal.load(encryptor.decrypt_and_verify(cookie))
end


# Time to test ... (With data from Arbeit327)
cookie = 'WVFQVTFtbmNxWWJPODZNb3NUMVZzZGtDVjZQNXpMYStFMWdiZlJPMkdjRFRBOGZ5T3pOTzBPKzk3NWxvQUJvTlRRU2t4MXZmdG8rT0I0R2M3Ulh0YXpxRVhNMll5UW1xUHhvVXBLbXozZ3ZyNjB4VDU4dWRIUkxBWjBXbDJhci93YkYrZWswUHdFL0hUNDJaUHo2cEpxbXFvdlFZMjJWVU9KTWhHb3NyalFwTkphd0pUQVZSTXRHbkVqRlFnSGpNVTNFQlVxYlRmT3pWbXNjK0JuQ3FydzQvODRhbmtuU29haGNRbXQ4T3o1ZjhqMk53WTRMa0pVd1hPb2NHTVFQY3dvanE2ZElqUk1Mc21HS0k2SHVuZEZ3OWhjdzZPQnRSMEdVVkQwL2IxSVh5QzNSWVlJZms5c1JJV0lzUE1Zb1NHbEtqYm5nTGRKd1ZSdGpOQ1RZZWthR1A2anRFMEluaTcyWTNaNHJBR1N0dklzMkg1RjVmVmY4azEzV3o0N2Z2LS1wQlowRUZ6cjI3SVFQU0F5bGlYSDNnPT0%3D--19650cc5c3e2599fb43b7235ab4de5a1ce8a46ac'
key = 'aeb977de013ade650b97e0aa5246813591104017871a7753fe186e9634c9129b367306606878985c759ca4fddd17d955207011bb855ef01ed414398b4ac8317b'

decrypt_session_cookie(cookie, key)

# RESULT SHOULD BE:
# {"session_id"=>"ed15f10de5708322d240eca41b7bbcd0", "_csrf_token"=>"yJK0VWRE6ykxOTnllfMt6pZE7SBhXgfZSQS2Fft0l8w=", 
#  "user_id"=>1, "project_ids"=>[1, 2, 3, 4], "role"=>"admin"}
