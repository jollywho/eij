require 'optparse'

module Eij

  key = ARGV[0]

  OptionParser.new { |opts|
    opts.banner = "Usage: #{File.basename($0)} -u -i -s filename"

    opts.on( '-j', '', 'japanese') do |arg|
      #
    end

    opts.on('-e', '', 'english') do |arg|
      #
    end

    opts.on('-d', '', 'damage') do |arg|
      #
    end
  }.parse!

end
