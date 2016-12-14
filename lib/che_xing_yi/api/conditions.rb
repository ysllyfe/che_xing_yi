module CheXingYi
  module Api
    module Conditions
      def get_condition
        http_get('InputsCondition.aspx', {from: app_id})
      end
    end
  end
end