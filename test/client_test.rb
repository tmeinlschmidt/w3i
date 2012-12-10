require_relative "test_helper"

class W3i::ClientTest < Test::Unit::TestCase

  def setup
    @client_options = {
      :device_generation_info => "iPhone4,1",
      :os_version => "1.1",
      :client_ip => "127.0.0.2",
      :udids => {
        W3i::IOSUDID => '13112312312312'
      },
      :app_id => 100,
      :api_host => 'api.example.com'
    }

    data = File.read("#{FIXTURES}/session.json")
    FakeWeb.allow_net_connect = 'http://api.example.com'
    FakeWeb.register_uri(:post, "http://api.example.com/PublicServices/MobileTrackingApiRestV1.svc/Session/Get", :body => data, :content_type => "application_json")
  end

  def test_initialize
    client = W3i::Client.new(@client_options.dup)
    assert_equal(@client_options[:device_generation_info], client.device_generation_info)
    assert_equal(@client_options[:os_version], client.os_version)
    assert_equal(@client_options[:udids], client.udids)
    assert_equal(@client_options[:app_id], client.app_id)
    assert_equal(@client_options[:client_ip], client.client_ip)
  end

  def test_no_device_generation_info
    @client_options.delete(:device_generation_info)
    assert_raise W3i::ApiDeviceGenerationNotSet do
      W3i::Client.new(@client_options)
    end
  end
  
  def test_no_os_version
    @client_options.delete(:os_version)
    assert_raise W3i::ApiOsVersionNotSet do
      W3i::Client.new(@client_options)
    end
  end
 
  def test_no_client_ip
    @client_options.delete(:client_ip)
    assert_raise W3i::ApiClientIPNotSet do
      W3i::Client.new(@client_options)
    end
  end
  
  def test_no_UDID
    @client_options.delete(:udids)
    assert_raise W3i::ApiUDIDsNotSet do
      W3i::Client.new(@client_options)
    end
  end
 
  def test_no_app_id
    @client_options.delete(:app_id)
    assert_raise W3i::ApiAppIDNotSet do
      W3i::Client.new(@client_options)
    end
  end

  # invalid api_host
  def test_invalid_api_host
    FakeWeb.allow_net_connect = true
    assert_raise W3i::UnknownError do
      @client = W3i::Client.new(@client_options.merge(:api_host => 'dummy.host'))
    end
  end

  def test_get_qualified_offers
    data = File.read("#{FIXTURES}/offers.json")
    FakeWeb.register_uri(:post, "http://api.example.com/PublicServices/AfppApiRestV1.svc/Offer/Qualified/Get", :body => data, :content_type => "application_json")
    @client = W3i::Client.new(@client_options)
    
    get_data = {
        "GetQualifiedOffersInputs" => {
          "OfferIndexStart" => 0,
          "OfferIndexStop" => 100,
          "SortColumn" => 0,
          "SortDirection" => W3i::Sort::Default
        }
    }

    @client.expects(:send_request).with('/PublicServices/AfppApiRestV1.svc/Offer/Qualified/Get', get_data).returns(JSON.parse(data))
    
    offers = @client.get_qualified_offers

    assert_equal(26, offers.offers.count)
    assert_equal(26, offers.total_offer_count)
    assert_equal(5971, offers.offers.first.id)
  end

  def test_save_offer_click
    data = File.read("#{FIXTURES}/save_offer_click.json")
    FakeWeb.register_uri(:post, "http://api.example.com/PublicServices/AfppApiRestV1.svc/Offer/Qualified/Get", :body => data, :content_type => "application_json")
    @client = W3i::Client.new(@client_options)
    
    get_data = {
      "OfferId" => 5971
    }

    @client.expects(:send_request).with('/PublicServices/AfppApiRestV1.svc/Device/Offer/Click/Put', get_data).returns(JSON.parse(data))
    
    offer_click = @client.save_offer_click(5971)
    assert_equal('http://click.linksynergy.com/fs-bin/stat?id=MiToMcjUEiE&offerid=146261&type=3&subid=0&tmpid=1826&u1=P%7c2791019971%7c11797&RD_PARM1=https%253a%252f%252fitunes.apple.com%252fca%252fapp%252freign-of-dragons%252fid531095755%253fmt%253d8%2526uo%253d4%2526partnerId%253d30', offer_click.redirect_url)
  end

end
