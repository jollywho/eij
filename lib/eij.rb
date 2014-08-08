require 'optparse'
require './eij/string.rb'

module Eij

  key = ARGV[0]

   key.contains_cjk?

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} key [-j word] | [-e word] | [-d num [char]]"

    opts.on( '-e', '--japanese [word]', 'to english') do |v|
      res = %x{bash -c "source ./func.sh; je #{key}"}
      res = res.gsub(":@;", "\n")
      print res.blue
      #
    end

    opts.on( '-j', '--english [word]', 'to japanese') do |v|
      res = %x{bash -c 'source ./func.sh; ej #{key}'}
      res = res.gsub(":@;", "\n")
      print res.blue
      #
    end

    opts.on( '-d', "--list [num[, char]]", Array, 'damage') do |v|
      print v[0].red
      print v[1].green
    end

  }.parse!

end
