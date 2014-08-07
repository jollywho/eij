require 'optparse'

module Eij

  key = ARGV[0]

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} key [-j word] | [-e word] | [-d num [char]]"


    opts.on( '-j', '--japanese WORD', 'japanese') do |v|
      p v
      #
    end

    opts.on( '-e', '--english WORD', 'english') do |v|
      p v
      #
    end

    opts.on( '-d', "--list NUM,char", Array, 'damage') do |v|
      p v
    end

  }.parse!

end
