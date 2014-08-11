# encoding: utf-8
module Eij
  class Translator

    def initialize
      @ch = 'a'
      @col = %x{bash -lic 'echo $COLUMNS'}
      @msg = ""
    end

    def jap(key)
      @msg = %x{bash -lic "source ./func.sh; jj #{key}"}
      format_jp
    end

    def to_eng(key)
      @msg = %x{bash -lic "source ./func.sh; je #{key}"}
      format_jp
    end

    def to_jap(key)
      @msg = %x{bash -lic 'source ./func.sh; ej #{key}'}
      format_jp
    end

    def format_jp
      @msg = @msg.gsub(":@;", "\n")
      @msg.strip!
      @msg = @msg.gsub(" \n", "")

      divs = @msg.split(/\n/)
      prim = divs[1..-1]
      prim_list = []
      offset = 0

      if prim.count > 52
        print "Results:#{prim.count}. Search query too vague!\n"
        exit
      end
      prim.each_with_index do |str, index|
        @ch = 'A' if @ch.ord == 123
        chm = "{#{@ch}} "
        if !str.include? "-->"
          prim_list[index] = "#{chm.colorize(index-offset)}#{str}"
          @ch = @ch.ord.next.chr
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
      @msg = %x{bash -lic 'source ./func.sh; dfind #{key}'}
      divs = @msg.split(":;!;")
      @msg = divs[0]
      @msg = @msg.gsub(":@;", "\n")
      @msg.strip!
      @msg += "\n"
      lookup_prims  divs[1] if divs[1].size > 0
      lookup_jukugo divs[2] if divs[2].size > 0
      lookup_usedin divs[3] if divs[3].size > 0
      print @msg
    end

    def lookup_prims(div)
      prim_list = []
      div.split("+").each_with_index do |str, index|
        chm = ":#{index}:"
        prim_list[index] = chm.colorize(index) + str.strip
      end
      prim_merge = prim_list.join(", ")
      @msg.sub!(div, "\n{#{@ch}} ".blue + prim_merge)
    end

    def lookup_jukugo(div)
      prim_list = []
      @ch = @ch.ord.next.chr
      offset = 0
      div.split("\n").each_with_index do |str, index|
        chm = "{#{@ch}} "
        if str[0].to_s.contains_cjk?
          prim_list[index] = "#{chm.colorize(index-offset)}#{str}"
          @ch = @ch.ord.next.chr
        else
          prim_list[index] = str
          offset += 1
        end
      end
      prim_merge = prim_list.join("\n")
      @msg.sub!(div, prim_merge)
    end

    def lookup_usedin(div)
      prim_list = []
      offset = 0
      strsize = 0
      div.split("\n").each_with_index do |str, index|
        @ch = 'A' if @ch.ord == 123
        chm = "{#{@ch}}"
        if str == "USED IN:"
          prim_list[index] = "\n" + str.strip + "\n"
          offset += 1
        elsif str.strip.size > 0
          if strsize + str.size * 2 >= @col.to_i
            newl = "\n"
            strsize = 0
          end
          prim_list[index] = "#{chm.colorize(index-offset)}#{str.strip}#{newl}"
          strsize += str.size
          @ch = @ch.ord.next.chr
        end
      end
      prim_merge = prim_list.join("")
      prim_merge.gsub!(", , ", "")
      @msg.sub!(div, prim_merge)
      @msg += "\n"
    end
  end
end
