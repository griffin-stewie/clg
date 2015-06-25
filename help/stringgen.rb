#!/usr/bin/env ruby
# encoding: UTF-8

inputText = ARGV[0]

str = String.new
open(inputText) {|file|
  while l = file.gets
    str << l.inspect + ",\n"
  end
}

puts str.chomp!.split(//u)[0..-2].join
