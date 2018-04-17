require 'dry-configurable'
require 'firebase_dynamic_link/client'
require 'firebase_dynamic_link/connection'
require 'firebase_dynamic_link/version'

module FirebaseDynamicLink
  extend Dry::Configurable

  # You can change it to
  # FirebaseDynamicLink.adapter = :patron
  # FirebaseDynamicLink.adapter = :httpclient
  # FirebaseDynamicLink.adapter = :net_http_persistent
  #
  # And get the value by
  # FirebaseDynamicLink.adapter
  setting :adapter
end
