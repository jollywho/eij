# encoding: utf-8
require 'optparse'
require 'eij/string.rb'
require 'eij/translator.rb'

module Eij

  key = ARGV[0]
  ARGV.shift

  a = Translator.new(key)

  if key.contains_cjk? && ARGV.size == 0
    a.jap
  end

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} key [-j word] | [-e word] | [-d num[,char]]"

    opts.on( '-e', '--japanese [word]', Array, 'to english') do |v|
      a.to_eng
      if !v.nil?
        a.grab_item v[1] if v.size == 2
        a.grab_inner_item v[1],v[2] if v.size >= 3
        a.grab_split v[3] if v.size >= 4
        a.grab_char v[4] if v.size >= 5
      end
    end

    opts.on( '-j', '--english [word]', Array, 'to japanese') do |v|
      a.to_jap
      if !v.nil?
        a.grab_item v[1] if v.size == 2
        a.grab_inner_item v[1],v[2] if v.size >= 3
        a.grab_char v[3] if v.size >= 4
      end
    end

    opts.on( '-d', "--list [char]", Array, 'damage') do |v|
      a.lookup
      if !v.nil?
        a.grab_item v[1] if v.size == 2
        a.grab_inner_item v[1],v[2] if v.size >= 3
        a.grab_split  v[3] if v.size >= 4
        a.grab_char v[4] if v.size >= 5
      end
    end

  }.parse!
  print a.out
end
