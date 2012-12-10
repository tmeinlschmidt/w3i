require_relative 'offer'

module W3i

=begin
  {
    "Violations": [],
    "Messages": [],
    "Log": [],
    "TotalOfferCount": 16,
    "Offers":[
      array of W3i::Offer
    ]
  }
=end

  class Offers < W3i::Struct
      
    attr_reader :offers

    def initialize(data)
      @offers = data.delete("Offers").map{|r| W3i::Offer.new(r)}
      super(data)
    end

  end

end
