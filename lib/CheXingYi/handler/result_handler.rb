module CheXingYi
  class ResultHandler
    attr_accessor :code, :msg, :result
    def initialize(code, result = {})
      @code = code || OK_CODE
      @msg = GLOBAL_CODES[@code.to_i]
      @result = package_result(result)
    end

    def is_ok?
      code == OK_CODE
    end
    alias_method :ok?, :is_ok?

    def full_message
      "#{code}: #{msg}."
    end

    def full_error_message
      full_message if !is_ok?
    end
    alias_method :full_error_messages, :full_error_message
    alias_method :errors, :full_error_message

    private
    def package_result(result)
      return result if !result.is_a?(Hash)
      if defined?(Rails)
        ActiveSupport::HashWithIndifferentAccess.new(result)
      else
        result
      end
    end
  end
end