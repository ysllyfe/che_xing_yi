require "monitor"
require "redis"
require 'digest/md5'
module CheXingYi
  class Client
    include MonitorMixin

    include Api::Conditions
    include Api::Violation


    attr_accessor :app_id, :app_secret
    attr_accessor :redis_key
    attr_accessor :conditions

    def initialize(app_id, app_secret, options={})
      @app_id = app_id
      @app_secret = app_secret
      @redis_key = security_redis_key(options[:redis_key] || "che_xing_yi_#{app_id}")
      super()
    end

    def conditions
      @condition ||= get_condition
    end

    # 暴露出：http_get,http_post两个方法，方便第三方开发者扩展未开发的微信API。
    def http_get(url, url_params={}, endpoint="api")
      url_params = url_params
      CheXingYi.http_get_without_token(url, url_params, endpoint)
    end

    def http_post(url, post_body={}, url_params={}, endpoint="api")
      url_params = access_token_param.merge(url_params)
      CheXingYi.http_post_without_token(url, post_body, url_params, endpoint)
    end

    private
    def security_redis_key(key)
      Digest::MD5.hexdigest(key.to_s).upcase
    end
  end
end