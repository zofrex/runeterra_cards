require File.expand_path('../lib/runeterra_cards/version', __FILE__)

Gem::Specification.new do |s|
  s.name    = "runeterra_cards"
  s.version = RuneterraCards::VERSION

  s.required_ruby_version = '>= 2.0'

  s.authors = ["zofrex"]
  s.email = ["zofrex@gmail.com"]
  s.summary = "Legends of Runeterra deck encoder/decoder and general purpose card info"
  s.description = s.summary
  s.licenses = ['MIT']

  s.executables   = []
  s.require_paths = ["lib"]
  s.files         = `git ls-files lib LICENSE.txt`.split("\n")

  s.add_development_dependency 'bundler', '~> 2.0'
end
