
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

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  ignored_files = [
    "Dockerfile", "docker-compose.yml",
    ".dockerignore",".gitignore",
    ".ruby-gemset",".ruby-version",
    ".rspec",
    ".travis.yml"
  ]
  spec.files = spec.files - ignored_files

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  spec.add_dependency 'clamp'
  spec.add_dependency 'websocket-eventmachine-server'
  spec.add_dependency 'eventmachine'
  spec.add_dependency 'faye-websocket'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
