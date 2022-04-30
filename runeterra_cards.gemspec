# frozen_string_literal: true

require File.expand_path('lib/runeterra_cards/version', __dir__)

Gem::Specification.new do |s|
  s.name    = 'runeterra_cards'
  s.version = RuneterraCards::VERSION

  s.required_ruby_version = '>= 2.6'

  s.author = 'James "zofrex" Sanderson'
  s.email = ['zofrex@gmail.com']
  s.summary = 'Legends of Runeterra deck code decoder & Data Dragon card data loader.'
  s.description = s.summary
  s.licenses = ['MIT']

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/zofrex/runeterra_cards/issues',
    'changelog_uri' => 'https://www.rubydoc.info/gems/runeterra_cards/file/doc/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/zofrex/runeterra_cards',
    'documentation_uri' => 'https://www.rubydoc.info/gems/runeterra_cards/',
    'rubygems_mfa_required' => 'true',
  }

  s.executables   = []
  s.require_paths = ['lib']
  s.files         = Dir['lib/**/*', 'LICENSE.txt', 'doc/**/*', '.yardopts']

  s.add_dependency 'base32', '~> 0.3.2'
  s.add_development_dependency 'deep-cover', '~> 0.7'
  s.add_development_dependency 'minitest', '~> 5.14'
  s.add_development_dependency 'minitest-reporters', '~> 1.4.2'
  s.add_development_dependency 'mutant', '~> 0.10.0'
  s.add_development_dependency 'mutant-minitest', '~> 0.10.0'
  s.add_development_dependency 'rake', '~> 13.0.1'
  s.add_development_dependency 'redcarpet', '~> 3.5.1'
  s.add_development_dependency 'rubocop', '~> 1.2'
  s.add_development_dependency 'rubocop-minitest', '~> 0.15.2'
  s.add_development_dependency 'rubocop-packaging', '~> 0.5.1'
  s.add_development_dependency 'rubocop-performance', '~> 1.8'
  s.add_development_dependency 'yard', '~> 0.9.25'
end
