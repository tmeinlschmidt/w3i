require_relative 'currency'

module W3i

=begin
  {
    "Id": 5325,
    "DisplayName": "Zynga Poker",        
    "IsFeatured": false,
    "SmallIconUrl": "http:\/\/img2.freeze.com\/mobile\/appicons\/zyngapoker.jpg",
    "PurchasePrice": 0.00,
    "PublisherPayoutAmount": 0.75,
    "ShortConversionActionMessage": "New heads-up Poker!",
    "FullConversionActionMessage": "",
    "SaveOfferClickUrl": "http:\/\/api.w3i.com\/AfppApi\/SaveOfferClick.aspx?SessionId=723273216&OfferId=5325&PublisherCurrencyId=305",
    "Currencies":[
      array of W3i::Currency
    ],
    "PayoutConversionType": 1
  }
=end

  class Offer < W3i::Struct
  
    attr_reader :currencies

    def initialize(data)
      @currencies = data.delete("Currencies").map{|r| W3i::Currency.new(r)}
      super(data)
    end

  end

end
