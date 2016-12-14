module CheXingYi
  module Api
    module Violation
      # 车牌号， 车架号， 引擎号
      def query(plate_no, frame_no = nil, engine_no = nil)
        http_get('queryindex.aspx', {userid: app_id, userpwd: app_secret, carnumber: plate_no, carcode: frame_no, cardrivenumber: engine_no})
      end
    end
  end
end