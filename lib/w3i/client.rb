module W3i

  class Client

    attr_reader :is_hacked                    # opt
    attr_reader :device_generation_info       # required
    attr_reader :publisher_sdk_version        # 'API'
    attr_reader :is_using_sdk                 # false
    attr_reader :publisher_user_id            # opt
    attr_reader :os_version                   # req
    attr_reader :client_ip                    # req
    attr_reader :udids                        # req array of udids
    attr_reader :app_id                       # req
    attr_reader :previous_session_end_time_utc  # N/A
    attr_reader :is_on_cellular               # false/true
    
    # POST - http://api.w3i.com/PublicServices/MobileTrackingApiRestV1.svc/Session/Get
    attr_reader :api_host
    attr_reader :api_url

    attr_reader :session
    attr_reader :raw_data

    def initialize(options = {})
      @is_hacked = options.delete(:is_hacked)   
      @device_generation_info = options.delete(:device_generation_info) || (raise W3i::ApiDeviceGenerationNotSet)
      @publisher_sdk_version = 'API'
      @is_using_sdk = false
      @publisher_user_id = options.delete(:publisher_user_id)
      @os_version = options.delete(:os_version) || (raise W3i::ApiOsVersionNotSet)
      @client_ip = options.delete(:client_ip) || (raise W3i::ApiClientIPNotSet)
      @udids = options.delete(:udids) || (raise W3i::ApiUDIDsNotSet)
      @app_id = options.delete(:app_id) || (raise W3i::ApiAppIDNotSet)
      @is_on_cellular = options.delete(:is_on_cellular) || true
      @api_host = options.delete(:api_host) || 'api.w3i.com'
      @api_url = options.delete(:api_url) || '/PublicServices/MobileTrackingApiRestV1.svc/Session/Get'

      initialize_session
    end

    def renew
      initialize_session
    end
    
    # send request
    def send_request(url, data)
      return false if @session.nil?
      data.merge!({"Session" => {"SessionId" => @session.session_id}})
      post_request(url, data)
    end

    # fetch qualified offers for given session
    def get_qualified_offers(start = 0, stop = 100, sort = W3i::Sort::Default)
      data = {
        "GetQualifiedOffersInputs" => {
          "OfferIndexStart" => start,
          "OfferIndexStop" => stop,
          "SortColumn" => 0,
          "SortDirection" => sort
        }
      }
      raw_data = send_request('/PublicServices/AfppApiRestV1.svc/Offer/Qualified/Get', data)
      
      W3i::Offers.new(raw_data)
    end

    # confirm click and get redirect info
    def save_offer_click(offer_id, currency_id = nil)
      data = {
        "OfferId" => offer_id
      }
      data.merge!({"PublisherCurrencyId" => currency_id}) unless currency_id.nil?
      raw_data = send_request('/PublicServices/AfppApiRestV1.svc/Device/Offer/Click/Put', data)
      W3i::OfferClick.new(raw_data)
    end

    private
  
    # send raw POST request, with data as post body data
    def post_request(url, data)

      http = Net::HTTP.new(@api_host, API_PORT)
      http.use_ssl = (API_PORT == 443)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      
      begin
        response = http.post(url, data, headers)
      rescue Exception => e
        raise W3i::UnknownError, e.message
      end
      
      json_data = JSON.parse(response.body)
      
      if response.code.to_i == 200
        return json_data
      else
        raise W3i::ApiError, message: "#{json_data['code']} - #{json_data['message']}"
      end

      false
    end

    # call API and initialie session
    def initialize_session
      query_data = {
        "IsHacked" => @is_hacked,
        "DeviceGenerationInfo" => @device_generation_info,
        "PublisherSDKVersion" => @publisher_sdk_version,
        "IsUsingSdk" => @is_using_sdk,
        "PublisherUserId" => @publisher_user_id,
        "OSVersion" => @os_version,
        "ClientIp" => @client_ip,
        "UDIDs" => parse_udids, 
        "AppId" => @app_id,
        "IsOnCellular" => @is_on_cellular
      }
      
      @raw_data = post_request(@api_url, query_data.to_json)
      @session = W3i::SessionData.new(@raw_data)

      true
    end

    def parse_udids
      list = []
      @udids.each do |type, udid|
        list << {"Value" => udid, "Type" => type}
      end
      list
    end

    def to_query(data = {})
      data.map{|k,v| "#{k.to_s}=#{URI.escape(v.to_s)}"}.join('&')
    end

    def headers
      {
       'User-Agent'   => "W3i-#{W3i::AGENT}",
       'Accept'       => 'application/json',
       'Content-Type' => 'application/json'
      }
    end

  end

end
