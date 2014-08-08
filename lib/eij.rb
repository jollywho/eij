require 'optparse'
require './eij/string.rb'

module Eij

  key = ARGV[0]

  p %x{bash -lic 'source ./func.sh; ej #{key}'}
  p key.contains_cjk?

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} key [-j word] | [-e word] | [-d num [char]]"

    opts.on( '-j', '--japanese WORD', 'japanese') do |v|
      puts v.red
      #
    end

    opts.on( '-e', '--english WORD', 'english') do |v|
      puts v.bg_green
      #
    end

    opts.on( '-d', "--list NUM,char", Array, 'damage') do |v|
      print v[0].blue, v[1].brown
    end

  }.parse!

end
