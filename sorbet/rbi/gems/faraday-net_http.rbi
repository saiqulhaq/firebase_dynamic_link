# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/faraday-net_http/all/faraday-net_http.rbi
#
# faraday-net_http-2.0.3

module Faraday
end
class Faraday::Adapter
end
class Faraday::Adapter::NetHttp < Faraday::Adapter
  def build_connection(env); end
  def call(env); end
  def configure_request(http, req); end
  def configure_ssl(http, ssl); end
  def create_request(env); end
  def encoded_body(http_response); end
  def initialize(app = nil, opts = nil, &block); end
  def net_http_connection(env); end
  def perform_request(http, env); end
  def request_via_get_method(http, env, &block); end
  def request_via_request_method(http, env, &block); end
  def request_with_wrapped_block(http, env, &block); end
  def ssl_cert_store(ssl); end
  def ssl_verify_mode(ssl); end
end
module Faraday::NetHttp
end
