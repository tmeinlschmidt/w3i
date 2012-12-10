require_relative "test_helper"

class W3i::StructTest < Test::Unit::TestCase

  def test_struct_object
    data = {
      "SampleData" => "abcd",
      "AnotherSampleData" => {
        "DataOne" => "one",
        "DataTwo" => "two"
      }
    }
    new_data = W3i::Struct.new(data)
    assert_equal("abcd", new_data.sample_data)
    assert_equal({"data_one"=>"one", "data_two"=>"two"}, new_data.another_sample_data)
  end

end
