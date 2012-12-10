module W3i
  
  class SessionData

    attr_reader :violations
    attr_reader :messages
    attr_reader :log
    attr_reader :session_id
    attr_reader :w3i_device_id
    attr_reader :is_afpp_offerwall_enabled

    def initialize(data)
      return nil if data.nil? || data == {}
      @violations = data['Violations'] || []
      @messages = data['Messages'] || []
      @log = data['Log'] || []
      @session_id = (data['Session']||{})['SessionId'].to_s
      @w3i_device_id = data['W3iDeviceId'].to_s
      @is_afpp_offerwall_enabled = data['IsAfppOfferwallEnabled']
      return self
    end

  end

end
