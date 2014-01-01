# RqrcodePngBin

command line interface for rqrcode_png

## Installation

    $ gem install rqrcode_png_bin

## Usage

    $ rqrcode_png STRING > qrcode.png

or

    $ rqrcode_png -f TSV_FILE

## TSV format

Two formats exists.

 1. 1 line : 1 text for encoding
 2. 1 line : 1 text for encoding\<TAB\>1 filename

If you choose format one, output filename is deterimined automatically from text for encoding (with CGI#escape).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
