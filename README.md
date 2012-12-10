# W3i

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'w3i'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install w3i

## Usage

    client_options = {
      :device_generation_info => "iPhone4,1",
      :os_version => "1.1",
      :client_ip => "127.0.0.2",
      :udids => {
        W3i::IOSUDID => '13112312312312'
      },
      :app_id => 100
    }
    client = W3i::Client.new(client_options)
    offers = client.get_qualified_offers
    ...
    redirect_info = client.save_click_offer(offer.offers.first.id)
    redirect_to redirect_info.redirect_url

offers are then in ``offers.offers`` and using ``get_qualified_offers`` you can paginate and sort

## Available options for Client

* ``is_hacked``
* ``device_generation_info`` -  **required**
* ``publisher_user_id`` - optional User ID
* ``os_version`` -  OS version **required**
* ``client_ip`` - IP address of User **required**
* ``udids`` - array of UDIDs **required**
* ``app_id`` - app ID **required**
* ``is_on_cellular`` - whether the device is on cellular
* ``api_host`` - optional API host
* ``api_url`` - optional API url

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
