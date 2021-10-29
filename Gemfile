# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  source 'https://oss:lT1n7OO5v1PIhFu3tv5QCbgDhA9Awe90@gem.mutant.dev' do
    # Required to license the `mutant` gem
    gem 'mutant-license'
  end
end

# Add just the gems needed to run unit tests to their own group, so we can install just these for running tests
# and skip the other dependencies. This saves time in the unit test job, and solves a problem where 'redcarpet'
# won't install under JRuby.
group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rake'
  gem 'yard'
end
