require 'optparse'
require './eij/string.rb'
require './eij/translator.rb'

module Eij

  key = ARGV[0]
  ARGV.shift

  a = Translator.new

  if key.contains_cjk?
    a.lookup key
  end

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} key [-j word] | [-e word] | [-d num[,char]]"

    opts.on( '-e', '--japanese [word]', 'to english') do |v|
      a.to_jap key
    end

    opts.on( '-j', '--english [word]', 'to japanese') do |v|
      a.to_eng key
    end

    opts.on( '-d', "--list [num[, char]]", Array, 'damage') do |v|
      a.lookup key
    end

  }.parse!

end
