
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "moonrelay/version"

Gem::Specification.new do |spec|
  spec.name          = "moonrelay"
  spec.version       = Moonrelay::VERSION
  spec.authors       = ["Matti Paksula"]
  spec.email         = ["matti.paksula@iki.fi"]

  spec.summary       = "moonrelay"
  spec.description   = "moonrelay"
  spec.homepage      = "https://github.com/matti/moonrelay"
  spec.license       = "MIT"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'clamp'
  spec.add_dependency 'websocket-eventmachine-server'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
