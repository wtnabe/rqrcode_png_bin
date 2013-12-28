require "optparse"
require "nkf"

module RqrcodePngBin
  class App
    def initialize(argv = [])
      @argv   = argv
      @size   = 4
      @level  = :m
      @canvas = nil

      parser.parse!(@argv)
    end
    attr_reader :size, :level, :canvas

    def run
      if str
        png = RQRCode::QRCode.new(str, opts).to_img
        png = png.resize(*canvas) if canvas

        STDOUT.puts png
      else
        STDERR.puts "rqrcode_png #{VERSION}", nil, parser.help
      end
    end

    #
    # [return] String
    #
    def str
      str = @argv.first
    end

    #
    # [return] Hash
    #
    def opts
      h = {
        :size  => @size,
        :level => @level
      }
    end

    #
    # [return] OptionParser
    #
    def parser
      OptionParser.new do |opt|
        opt.version = VERSION
        opt.banner  = "Usage: rqrcode_png [option] string"
        opt.on('-s', '--size SIZE (default 4)') {|v|
          re = %r{\A[0-9]+\z}

          if v =~ re
            @size = v.to_i
          else
            raise ArgumentError, "option size should match #{re}"
          end
        }
        opt.on('-l', '--level LEVEL (default m)') {|v|
          options = %w(l m q h)

          if options.include?(v)
            @level = v.to_sym
          else
            raise ArgumentError, "option level should be included #{options}"
          end
        }
        opt.on('-c', '--canvas CANVAS (ex 200x200)') {|v|
          re = %r{\A([0-9]+)x([0-9]+)\z}

          if v =~ re
            @canvas = [$1.to_i, $2.to_i]
          else
            raise ArgumentError, "option canvas should match #{re}"
          end
        }
      end
    end
  end
end
