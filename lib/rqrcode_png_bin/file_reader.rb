module RqrcodePngBin
  class FileReader
    def initialize(file)
      @file = open(file, 'r:utf-8')
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
        block.call(@str, @dest) if @str and @dest
      }
    end

    #
    # [param] String line
    #
    def split!(line)
      @pat =~ line

      @str  = $1
      @dest = $2 ? $2 : "#{$1.gsub(/\//, '%2F')}.png" if $1
    end
  end
end
