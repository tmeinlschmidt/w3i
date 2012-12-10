require "test/unit"
require "fakeweb"
require "mocha/setup"

require_relative "../lib/w3i"

class Test::Unit::TestCase
  FIXTURES = "#{File.dirname(__FILE__)}/fixtures"
end
