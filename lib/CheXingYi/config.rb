module CheXingYi
  class << self
    attr_accessor :config
    def configure
      yield self.config ||= Config.new
    end

    def che_xing_yi_redis
      return nil if config.nil?
      @redis ||= config.redis
    end

    def rest_client_options
      if config.nil?
        return {timeout: 5, open_timeout: 5, verify_ssl: false}
      end
      config.rest_client_options
    end

    def api_url
      config.api_url
    end
  end

  class Config
    attr_accessor :redis, :rest_client_options, :api_url
  end
end