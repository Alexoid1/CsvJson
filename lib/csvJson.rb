# frozen_string_literal: true

#module CsvJson
  #class Error < StandardError; end
  # Your code goes here...
#end

require 'rubygems'
require 'csv'
require 'json'
require 'orderedhash'
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
    
    module_function :parse
    module_function :convert
    
end