# frozen_string_literal: true

require File.expand_path('lib/runeterra_cards/version', __dir__)

Gem::Specification.new do |s|
  s.name    = 'runeterra_cards'
  s.version = RuneterraCards::VERSION

  s.required_ruby_version = '>= 2.5'

  s.authors = ['zofrex']
  s.email = ['zofrex@gmail.com']
  s.summary = 'Legends of Runeterra deck encoder/decoder and general purpose card info'
  s.description = s.summary
  s.licenses = ['MIT']

  s.executables   = []
  s.require_paths = ['lib']
  s.files         = Dir['lib/**/*', 'LICENSE.txt']

  s.add_dependency 'base32', '~> 0.3.2'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'minitest', '~> 5.14'
  s.add_development_dependency 'minitest-reporters', '~> 1.4.2'
  s.add_development_dependency 'rake', '~> 13.0.1'
  s.add_development_dependency 'rubocop', '~> 0.89.1'
  s.add_development_dependency 'rubocop-minitest', '~> 0.10.1'
  s.add_development_dependency 'rubocop-packaging', '~> 0.3.0'
  s.add_development_dependency 'warning', '~> 1.1.0'
  s.add_development_dependency 'yard', '~> 0.9.25'
end
