module Eij
  class Translator
    attr_reader :msg

    def initialize
    end

    def jap(key)
      msg = %x{bash -lic "source ./func.sh; jj #{key}"}
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      divs = msg.split(/\n/)
      prim = divs[1..-1]

      prim_merge = prim.join("\n")
      prim_merge += "\n"
      print prim_merge
    end

    def to_eng(key)
      msg = %x{bash -lic "source ./func.sh; je #{key}"}

      msg = msg.gsub(":@;", "\n")
      msg.strip!
      divs = msg.split(/[1-9]\./)
      prim = divs[1..-1]

      ch = 'A'
      prim_list = []
      n = 0

      prim.each do |str|
        chm = "{#{ch}} "
        prim_list[n] = chm.colorize(n) + str.strip
        n+=1
        ch = ch.ord.next.chr
      end
      prim_merge = prim_list.join("\n")
      prim_merge += "\n"
      print prim_merge
    end

    def to_jap(key)
      msg = %x{bash -lic 'source ./func.sh; ej #{key}'}
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg = msg.gsub(" \n", "")

      divs = msg.split(/\n/)
      prim = divs[1..-1]
      prim_list = []
      ch = 'a'

      if prim.count > 26
        print "Results:#{prim.count}. Search query too vague!\n"
        exit
      end
      prim.each_with_index do |str, index|
        chm = "{#{ch}} "
        if str.contains_cjk?
          prim_list[index] = "#{chm.colorize(index)}#{str}"
          ch = ch.ord.next.chr
        else
          prim_list[index] = "#{str}"
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
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg += "\n"

      ch = 'A'
      prim_list = []
      #ch = ch.ord.next.chr
      prim.split("+").each_with_index do |str, index|
        chm = ":#{index}: "
        prim_list[index] = chm.colorize(index) + str.strip
      end
      prim_merge = prim_list.join(" , ")
      msg.sub!(prim, "\n|".gray + "A".red.reverse_color + "| ".gray + prim_merge)

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
    end
  end
end
