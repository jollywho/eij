module Eij
  class Translator
    attr_reader :msg

    def initialize
    end

    def to_jap(key)
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

    def to_eng(key)
      msg = %x{bash -lic 'source ./func.sh; ej #{key}'}
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg = msg.gsub(" \n", "")

      divs = msg.split(/\n/)
      prim = divs[1..-1]
      prim_list = []
      ch = 'A'
      offset = 0

      prim.each_with_index do |str, index|
        chm = ":#{offset}: "
        spc = offset.to_s.size == 1 ? " " : ""
        if str.contains_cjk?
          prim_list[index] = "#{chm.colorize(offset)}#{spc}#{str}"
          offset += 1
        elsif !str.blank?
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

      #find primitives line
      #add letter A
      #split primitives by '+'
      #add incrementing number in front of each split
      #print new color each split
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

      print msg
    end
  end
end
