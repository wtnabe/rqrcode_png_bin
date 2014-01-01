require "cgi"

module RqrcodePngBin
  class FileReader
    def initialize(file)
      @file = open(file)
      @pat  = %r{\A([^\t]+)(?:\t([^\t]+))?\z}

      @str  = nil
      @dest = nil
    end

    #
    # [param] Proc block
    #
    def each(&block)
      @file.each_line {|line|
        split!(line.chomp)
        block.call(@str, @dest)
      }
    end

    #
    # [param] String line
    #
    def split!(line)
      @pat =~ line

      @str  = $1
      @dest = $2 ? $2 : "#{CGI.escape($1)}.png"
    end
  end
end
