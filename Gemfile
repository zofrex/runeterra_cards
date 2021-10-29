# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

source 'https://oss:lT1n7OO5v1PIhFu3tv5QCbgDhA9Awe90@gem.mutant.dev' do
  group :development do
    # Required to license the `mutant` gem
    gem 'mutant-license'
  end
end

# Put redcarpet in a group so we can skip installing it in the unit test configuration
# Needed because it won't install under JRuby
group :redcarpet do
  # Used for getting good markdown in Yard docs
  gem 'redcarpet'
end
