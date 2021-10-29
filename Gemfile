# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Seperate out gems we don't need to run unit tests
# This:
#  * makes unit tests run faster by skipping installing these gems
#  * helps avoid issue where 'redcarpet' fails to install under JRuby
group :development do
  source 'https://oss:lT1n7OO5v1PIhFu3tv5QCbgDhA9Awe90@gem.mutant.dev' do
    # Required to license the `mutant` gem
    gem 'mutant-license'
  end

  gem 'deep-cover'
  gem 'mutant'
  gem 'mutant-minitest'
  gem 'redcarpet'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
end
