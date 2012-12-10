module W3i
  
  class Struct < OpenStruct

    def initialize(data)
      @data = normalize_keys(data)
      super(@data)
    end

    private

    # convert SomeKey to some_key to be able to easily call this
    def normalize_keys(data)
      new_data = {}
      data.each do |k, v|
        if v.class == Hash || (defined?(::Rails) && v.class == HashWithIndifferentAccess)
          new_data[my_underscore(k)] = normalize_keys(v)
        else
          new_data[my_underscore(k)] = v
        end
      end
      new_data
    end

    def my_underscore(data)
      word = data.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
    end

  end

end
