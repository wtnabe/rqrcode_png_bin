require "optparse"

module RqrcodePngBin
  class App
    def initialize(argv = [])
      @argv   = argv

      @border_modules = 4
      @canvas = nil
      @file   = nil
      @level  = :m
      @mode   = nil
      @px_per_module = nil
      @size   = 4
      @stdin  = nil
      @try_larger = false

      parser.parse!(@argv)
    end
    attr_reader :border_modules, :canvas, :file, :level, :mode, :px_per_module, :size, :stdin

    def run
      if file
        FileReader.new(file).each {|str, dest|
          FileUtils.mkdir_p(File.dirname(dest))
          open(dest, 'wb') {|f|
            f.puts generate_png(str)
          }
        }
      elsif str
        STDOUT.puts generate_png(str)
      else
        STDERR.puts "rqrcode_png #{VERSION}", '', parser.help
      end
    end

    def generate_png(str)
      qr_opts = opts.dup

      begin
        RQRCode::QRCode.new(encoded_str(str), qr_opts).as_png(png_opts)
      rescue RQRCode::QRCodeRunTimeError => e
        if @try_larger && qr_opts[:size] < 40
          qr_opts[:size] = qr_opts[:size] + 1
          STDERR.puts "retrying #{str} with options #{qr_opts}"
          retry
        else
          raise e
        end
      end
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

      h[:mode] = @mode if @mode

      h
    end

    def png_opts
      h = {}

      h[:size]           = canvas if canvas
      h[:border_modules] = border_modules
      h[:module_px_size] = px_per_module  if px_per_module

      h
    end

    #
    # [return] OptionParser
    #
    def parser
      OptionParser.new do |opt|
        opt.version = VERSION
        opt.banner  = "Usage: rqrcode_png [option] string"

        opt.on('-b', '--border-modules BORDER') {|v|
          if v =~ /\A[0-9]+\z/
            @border_modules = v.to_i
          else
            raise ArgumentError, "option border modules should be integer"
          end
        }
        opt.on('-c', '--canvas CANVAS (ex 200)') {|v|
          if v =~ /\A[0-9]+\z/
            @canvas = v.to_i
          else
            raise ArgumentError, "option canvas should match be integer"
          end
        }
        opt.on('-f', '--from-file FILE') {|v|
          if File.exist?(v)
            @file = v
          else
            raise ArgumentError, "file you specified '#{v}' does not exist"
          end
        }
        opt.on('-l', '--level l|m|q|h (default m)') {|v|
          options = %w(l m q h)

          if options.include?(v)
            @level = v.to_sym
          else
            raise ArgumentError, "option level should be included #{options}"
          end
        }
        opt.on('-m', '--mode MODE') {|v|
          options = %w(number alphanumeric byte_8bit)

          if options.include?(v)
            @mode = v.to_sym
          else
            raise ArgumentError, "option mode should be included #{options}"
          end
        }
        opt.on('-p', '--pixels-per-module PIXELS') {|v|
          if v =~ /\A[0-9]+\z/
            @px_per_module = v.to_i
          else
            raise ArgumentError, "option pixels per module should be integer"
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
        opt.on('-t', '--try-larger') {|v|
          @try_larger = true
        }
      end
    end
  end
end
