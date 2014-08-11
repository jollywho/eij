# encoding: utf-8
require 'optparse'
require './eij/string.rb'
require './eij/translator.rb'

module Eij

  key = ARGV[0]
  ARGV.shift

  a = Translator.new

  if key.contains_cjk? && ARGV[0] != "-d"
    a.jap key
  end

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} key [-j word] | [-e word] | [-d num[,char]]"

    opts.on( '-e', '--japanese [word]', Array, 'to english') do |v|
      a.to_eng key
      if !v.nil?
        a.grab_item v[1] if v.size == 2
        a.grab_inner_item v[1],v[2] if v.size == 3
      end
    end

    opts.on( '-j', '--english [word]', Array, 'to japanese') do |v|
      a.to_jap key
      if !v.nil?
        a.grab_item v[1] if v.size == 2
        a.grab_inner_item v[1],v[2] if v.size == 3
      end
    end

    opts.on( '-d', "--list [char]", Array, 'damage') do |v|
      a.lookup key
      if !v.nil?
        a.grab_item v[1] if v.size == 2
        a.grab_inner_item v[1],v[2] if v.size == 3
      end
    end

  }.parse!
  print a.out
end
