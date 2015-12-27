# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip/upyun/version'

Gem::Specification.new do |spec|
  spec.name          = "paperclip-upyun"
  spec.version       = Paperclip::Upyun::VERSION
  spec.author       = "Edison-Hsu"
  spec.email         = ["edison.hsu.sh@gmail.com"]
  spec.summary       = "UPYUN API SDK for Paperclip Storage Plugin"
  spec.description   = <<-EOF
    UPYUN API SDK for Paperclip Storage Plugin. Use Upyun SDK to upload file.
  EOF
  spec.homepage      = "https://github.com/Edison-Hsu/paperclip-upyun"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "upyun", "~> 1.0"

  spec.add_development_dependency "rspec", "~> 2.6"
end
