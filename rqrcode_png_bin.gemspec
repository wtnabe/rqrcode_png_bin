# -*- mode: ruby; coding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rqrcode_png_bin/version'

Gem::Specification.new do |spec|
  spec.name          = "rqrcode_png_bin"
  spec.version       = RqrcodePngBin::VERSION
  spec.authors       = ["wtnabe"]
  spec.email         = ["wtnabe@gmail.com"]
  spec.description   = %q{command line interface for rqrcode}
  spec.summary       = %q{command line interface for rqrcode}
  spec.homepage      = "https://github.com/wtnabe/rqrcode_png_bin"
  spec.license       = "BSD"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rqrcode", "~> 0.10"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
