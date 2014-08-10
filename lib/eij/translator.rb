module Eij
  class Translator
    attr_reader :msg

    def initialize
    end

    def jap(key)
      msg = %x{bash -lic "source ./func.sh; jj #{key}"}
      format_jp msg
    end

    def to_eng(key)
      msg = %x{bash -lic "source ./func.sh; je #{key}"}
      format_jp msg
    end

    def to_jap(key)
      msg = %x{bash -lic 'source ./func.sh; ej #{key}'}
      format_jp msg
    end

    def format_jp(msg)
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg = msg.gsub(" \n", "")

      divs = msg.split(/\n/)
      prim = divs[1..-1]
      prim_list = []
      ch = 'a'
      offset = 0

      if prim.count > 52
        print "Results:#{prim.count}. Search query too vague!\n"
        exit
      end
      prim.each_with_index do |str, index|
        ch = 'A' if ch.ord == 123
        chm = "{#{ch}} "
        if !str.include? "-->"
          prim_list[index] = "#{chm.colorize(index-offset)}#{str}"
          ch = ch.ord.next.chr
        else
          prim_list[index] = "#{str}"
          offset += 1
        end
      end
      prim_merge = prim_list.join("\n")
      prim_merge += "\n"
      print prim_merge
    end

    def lookup(key)
      msg = %x{bash -lic 'source ./func.sh; dfind #{key}'}
      divs = msg.split(":;!;")
      msg = divs[0]
      prim = divs[1]
      jukugo = divs[2]
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg += "\n"

      ch = 'a'
      prim_list = []
      prim.split("+").each_with_index do |str, index|
        chm = ":#{index}:"
        prim_list[index] = chm.colorize(index) + str.strip
      end
      prim_merge = prim_list.join(", ")
      msg.sub!(prim, "\n{#{ch}} ".blue + prim_merge)

      ch = 'b'
      prim_list = []
      offset = 0
      jukugo.split("\n").each_with_index do |str, index|
        chm = "{#{ch}} "
       if str[0].to_s.contains_cjk?
         prim_list[index] = "#{chm.colorize(index-offset)}#{str}"
         ch = ch.ord.next.chr
       else
         prim_list[index] = str
         offset += 1
       end
      end
      prim_merge = prim_list.join("\n")
      msg.sub!(jukugo, prim_merge)

      #inside full record
      #copy rows between JUKUGO: and {end}|USED IN:|LOOKALIKES:
      #use ruby array[0] to check for kanji lines
      #add letter to each element starting with a B
      #split each 'word' in the line and increment number in front of each split
      #print new color each split

      #from USED IN: to bottom
      #split USED IN: from full record
      #specify use with argument -u (damage used in)
      #add letter to each element starting with a B

      print msg
      #print jukugo
    end
  end
end
