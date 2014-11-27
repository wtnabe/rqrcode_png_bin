require "optparse"

module RqrcodePngBin
  class App
    def initialize(argv = [])
      @argv   = argv

      @canvas = nil
      @file   = nil
      @level  = :m
      @size   = 4
      @stdin  = nil

      parser.parse!(@argv)
    end
    attr_reader :canvas, :file, :level, :size, :stdin

    def run
      if file
        FileReader.new(file).each {|str, dest|
          open(dest, 'wb') {|f|
            f.puts generate_png(encoded_str(str))
          }
        }
      elsif str
        STDOUT.puts generate_png(encoded_str(str))
      else
        STDERR.puts "rqrcode_png #{VERSION}", '', parser.help
      end
    end

    def generate_png(str)
      png = RQRCode::QRCode.new(str, opts).to_img
      png = png.resize(*canvas) if canvas

      png
    end

    def encoded_str(str)
      str.encode('SJIS').force_encoding('ASCII-8BIT')
    end

    #
    # [return] String
    #
    def str
      if @argv.first
        @argv.first
      else
        @stdin ||= $stdin.gets
        stdin if stdin.size > 0
      end
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

        opt.on('-c', '--canvas CANVAS (ex 200x200)') {|v|
          re = %r{\A([0-9]+)x([0-9]+)\z}

          if v =~ re
            @canvas = [$1.to_i, $2.to_i]
          else
            raise ArgumentError, "option canvas should match #{re}"
          end
        }
        opt.on('-f', '--from-file FILE') {|v|
          if File.exist?(v)
            @file = v
          else
            raise ArgumentError, "file you specified '#{v}' does not exist"
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
        opt.on('-s', '--size SIZE (default 4)') {|v|
          re = %r{\A[0-9]+\z}

          if v =~ re
            @size = v.to_i
          else
            raise ArgumentError, "option size should match #{re}"
          end
        }
      end
    end
  end
end
