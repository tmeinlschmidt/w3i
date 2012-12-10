require_relative "test_helper"

class W3i::SessionDataTest < Test::Unit::TestCase

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
  end

  def test_session_data
    data = File.read("#{FIXTURES}/session.json")
    FakeWeb.allow_net_connect = 'http://api.example.com'
    FakeWeb.register_uri(:post, "http://api.example.com/PublicServices/MobileTrackingApiRestV1.svc/Session/Get", :body => data, :content_type => "application/json")
    @client = W3i::Client.new(@client_options)
    assert_equal('2791019971', @client.session.session_id)
    assert_equal('472658300', @client.session.w3i_device_id)
  end

end
