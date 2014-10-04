# encoding: utf-8
require 'optparse'
require 'eij/string.rb'
require 'eij/translator.rb'

module Eij

  if ARGV.size == 0
    exit
  end
  key = ARGV[0]
  ARGV.shift

  cjk_args = key.split(',')
  a = Translator.new(cjk_args[0])

  if key.contains_cjk? && ARGV.size == 0
    a.jap
    a.grab_item cjk_args[1] if cjk_args.size == 2
    a.grab_inner_item cjk_args[1], cjk_args[2] if cjk_args.size >= 3
    a.grab_char cjk_args[3] if cjk_args.size >= 4
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
