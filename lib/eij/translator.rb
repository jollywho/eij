# encoding: utf-8
module Eij
  class Translator

    def initialize(key)
      @src = File.dirname(__FILE__) + "/func.sh"
      @func = File.dirname(__FILE__) + "/../../data/kanjidicks.txt"
      @col = %x{bash -lic 'echo $COLUMNS'}
      @msg = key
      @res = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
      ch_reset
    end

    def ch_reset
      @ch = 'a'
    end

    def exit_msg(res)
      "Results: #{res}. Search query too vague!\n"
    end

    def jap
      @msg = %x{bash -lic 'source #{@src}; jj #{@msg}'}
      format_jp
    end

    def to_eng
      @msg = %x{bash -lic 'source #{@src}; je #{@msg}'}
      format_jp
    end

    def to_jap
      if @msg.contains_cjk?
        jap
      else
        @msg = %x{bash -lic "source #{@src}; ej #{@msg}"}
        format_jp
      end
    end

    def grab_item(key)
      ch_reset
      if @res[key].size > 1
        @msg = @res[key].map do |x|
          "#{x[0]}#{x[1]}"
        end
        @msg = @msg.join
      else
        @msg = @res[key][1]
      end
    end

    def grab_char(ch)
      @msg = @msg[ch.to_i-1].strip + "\n"
    end

    def grab_split(i)
      @msg = @msg.split(' ')[i.to_i-1].strip + "\n"
    end

    def grab_inner_item(key, i)
      ch_reset
      @msg = @res[key][i.to_i].strip + "\n"
    end

    def out
      @msg = %x{source #{@src}; fmt_msg "#{@msg}"}
      print @msg.strip + "\n"
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
        print exit_msg prim.count
        exit
      end
      prim.each_with_index do |str, index|
        @ch = 'A' if @ch.ord == 123
        chm = "{#{@ch}} "
        if !str.include? "-->"
          prim_list[index] = "#{chm.colorize(index-offset)}#{str}"

          indx = 0
          str.split(/\d\./).each do |split|
            if split.split.size > 0
              indx += 1
              @res[@ch][indx] = "#{split}"
            end
          end
          @ch = @ch.ord.next.chr
        else
          prim_list[index] = "#{str}"
          offset += 1
        end
      end
      prim_merge = prim_list.join("\n")
      prim_merge += "\n"
      @msg.sub!(@msg, prim_merge)
    end

    def print_num_lines
      lst = {}
      @msg.split("\n").each_with_index do |str, index|
        if index > 0
          print "#{(index).to_s.rjust(2).colorize(index)}#{str}\n"
          lst[(index).to_s] = str.split(" ")[0]
        end
      end

      print "#: "
      begin
        @msg = lst[gets.strip]
      rescue Exception => e
        exit
      end
      lookup
    end

    def lookup
      @msg = %x{bash -ic 'source #{@src}; dfind #{@msg.strip} #{@func}'}
      divs = @msg.split(":;!;")
      @msg = divs[0]
      @msg = @msg.gsub(":@;", "\n")
      @msg.strip!
      if @msg.include? "No matches found:"
        print exit_msg 0
        exit
      elsif @msg.include? "Disambiguation required:"
        print "Disambiguation required:\n"
        print_num_lines
      else
        @msg += "\n"
        lookup_prims  divs[1] if divs[1].size > 0
        lookup_jukugo divs[2] if divs[2].size > 0
        lookup_usedin divs[3] if divs[3].size > 0
      end
    end

    def lookup_prims(div)
      prim_list = []
      div.split("+").each_with_index do |str, index|
        chm = ":#{index+1}:"
        prim_list[index] = chm.colorize(index) + str.strip
        @res[@ch][index+1] = " " + str.strip + " "
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
          @res[@ch][1] = str.strip
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
      strsizetotal = 0
      div.split("\n").each_with_index do |str, index|
        if @ch[-1] == 'z'
          @ch[0,0] = '1'
          @ch[-1] = 'a'
        end
        chm = "{#{@ch}}"
        if str == "USED IN:"
          prim_list[index] = "\n" + str.strip + "\n"
          offset += 1
        elsif str.strip.size > 0
          if strsizetotal + str.size + @ch.size >= @col.to_i/2
            newl = "\n"
            strsizetotal = 0
          end
          prim_list[index] = "#{chm.colorize(index-offset)}#{str.strip}#{newl}"
          @res[@ch][1] = str.strip
          strsizetotal += str.size
          @ch[-1] = @ch[-1].ord.next.chr
        end
      end
      prim_merge = prim_list.join("")
      prim_merge.gsub!(", , ", "")
      @msg.sub!(div, prim_merge)
    end
  end
end
