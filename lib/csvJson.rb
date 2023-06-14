# frozen_string_literal: true

#module CsvJson
  #class Error < StandardError; end
  # Your code goes here...
#end

require 'rubygems'
require 'csv'
require 'json'

require_relative "csvJson/version"


module CsvJson

    # convert an input string value to integer or float if applicable
    def convert(val)
        return Integer(val) if val.to_i.to_s == val
        Float(val) rescue val
    end

    # input and output are file objects, you can use StringIO if you want to work in memory
    def parse(input, output, headers=nil, csvOptions={}, gemOptions={})
        result = Array.new

        CSV.new(input, csvOptions).each do |row|
            # treat first row as headers if the caller didn't provide them
            unless headers 
                headers = row
                next
            end

            if gemOptions[:skipFirstRow] then
                gemOptions[:skipFirstRow] = false
                next
            end
            
            # build JSON snippet and append it to the result
            snippet = OrderedHash.new
            headers.each_index { |i| snippet[headers[i]] = self.convert(row[i]) }
            result << snippet
        end
        
        if gemOptions[:pretty] == true then
            output << JSON.pretty_generate(result)
        else
            output << JSON.generate(result)
        end



    end

    def self.to_json(data)
        for_csv = CSV.parse(data, headers: true, header_converters: :symbol)    

        arr_to_json = for_csv.map(&:to_h).to_json
        
        arr=JSON.parse(arr_to_json)
        
        puts arr
    end
    
    module_function :parse
    module_function :convert
    

end

puts 'ghfdg'


CsvJson.to_json("file,text,number,hex
test15.csv,AYF,
test15.csv,HNZjPHZD,,
test15.csv,D,,
test15.csv,OorvCJbngB,,
test15.csv,FHXKhHtDMZjjAKkN,,
test15.csv,rNuxDu,,
test15.csv,IUVBXuLCByha,,
test15.csv,FxruSKnpRppocymDtSFAkfgHXeQbgiCe,,
test15.csv,nEb,,,,
test15.csv,AKLU
test15.csv,SXUXqJqqcRiyXEklhhjA,,
test15.csv,WufGoffllJJgokHcMuJusiDhqZT,,
test15.csv,dIllKP,,
test15.csv,IQCDIEUrjRs,,
test15.csv,UjkuOrSjBVXTWKuwqSenNpXqaRM,,
test15.csv,XcGsLnNnTmOATuHtYdOKcNVeZNOJ,,")