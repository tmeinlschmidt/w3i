module W3i

  IOSUDID           = 1
  AndroidDeviceID   = 3
  AndroidID         = 4
  IOSOpenUDID       = 8
  IOSMD5WLANMAC     = 9
  IOSSha1HashedMac  = 10
  IOSIDFA           = 11

  API_PORT = 80 # to be easily changable
  AGENT    = 'W3i.gem'

  # constants for sorting Offers
  module Sort
    
    Default         = 0
    DisplayName     = 1
    PurchasePrice   = 2
    DevicePayout    = 3
    PublisherPayout = 4

  end

end
