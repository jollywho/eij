module Eij
  class Translator
    attr_reader :msg

    def initialize
    end

    def to_jap(key)
      msg = %x{bash -c "source ./func.sh; je #{key}"}
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg += "\n"
      print msg
    end

    def to_eng(key)
      msg = %x{bash -c 'source ./func.sh; ej #{key}'}
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg += "\n"
      print msg
    end

    def lookup(key)
      msg = %x{bash -c 'source ./func.sh; dfind #{key}'}
      divs = msg.split(":;!;")
      msg = divs[0]
      prim = divs[1]
      msg = msg.gsub(":@;", "\n")
      msg += "\n"
      msg.strip!

      #find primitives line
      #add letter A
      #split primitives by '+'
      #add incrementing number in front of each split
      #print new color each split

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
