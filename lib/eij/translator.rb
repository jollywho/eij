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
      msg = msg.gsub(":@;", "\n")
      msg.strip!
      msg += "\n"
      print msg.green
    end
  end
end
