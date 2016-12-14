require "rest-client"
if defined? Yajl
  require 'yajl/json_gem'
else
  require 'json'
end
require "CheXingYi/version"
require "CheXingYi/config"
require "CheXingYi/handler"
require "CheXingYi/api"
require "CheXingYi/client"

module CheXingYi

  OK_MSG  = "ok".freeze
  OK_CODE = 0.freeze
  # 用于标记endpoint可以直接使用url作为完整请求API
  CUSTOM_ENDPOINT = "custom_endpoint".freeze
  class << self

    def http_get_without_token(url, url_params={}, endpoint="api")
      get_api_url = endpoint_url(endpoint, url)
      load_json(resource(get_api_url).get(params: url_params))
    end

    def http_post_without_token(url, post_body={}, url_params={}, endpoint="api")
      post_api_url = endpoint_url(endpoint, url)
      # to json if invoke "plain"
      if endpoint == "api" || endpoint == CUSTOM_ENDPOINT
        post_body = JSON.dump(post_body)
      end
      load_json(resource(post_api_url).post(post_body, params: url_params))
    end

    def resource(url)
      RestClient::Resource.new(url, rest_client_options)
    end

     # return hash
    def load_json(string)
      result_hash = JSON.parse(string.force_encoding("UTF-8").gsub(/[\u0011-\u001F]/, ""))
      code   = result_hash.delete("ErrorCode")
      en_msg = result_hash.delete("ErrMessage")
      ResultHandler.new(code, result_hash)
    end

    def endpoint_url(endpoint, url)
      # 此处为了应对第三方开发者如果自助对接接口时，URL不规范的情况下，可以直接使用URL当为endpoint
      return url if endpoint == CUSTOM_ENDPOINT
      send("#{endpoint}_endpoint") + url
    end

    def api_endpoint
      api_url
    end

  end
end
