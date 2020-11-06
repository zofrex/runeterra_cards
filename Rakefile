# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'bundler'
Bundler.require

require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

task :add_pending_cops do
  # Only require this if we need it, it takes a while
  require 'rubocop'
  config_store = RuboCop::ConfigStore.new
  config = config_store.for(__dir__)
  pending = config.pending_cops
  next if pending.empty?

  File.open(File.join(__dir__, '.rubocop_pending.yml'), 'a') do |config_file|
    pending.each do |cop|
      config_file.puts
      config_file.puts "#{cop.name}:"
      config_file.puts '  Enabled: true'
    end
  end

  puts "Added #{pending.length} cops to .rubocop_pending.yml"
end

desc 'Fast and approximate code coverage checking (branch-level coverage checking)'
task :coverage do
  sh 'bundle exec deep-cover clone rake test'
end

desc 'Thorough code coverage checking via mutation testing (semantic coverage checking)'
task :mutation_test do
  sh "bundle exec mutant run --include lib --require 'runeterra_cards' --use minitest -- 'RuneterraCards*'"
end

desc 'Incremental mutation testing (tests everything that has changed since the most recent commit)'
task :mutation_test_incremental do
  sh "bundle exec mutant run --include lib --require 'runeterra_cards' --use minitest --since HEAD -- 'RuneterraCards*'"
end

task :check_versions_match do
  found_gemfile_instructions = false
  found_gemspec_instructions = false

  Dir.glob('doc/**.md').each do |doc_file|
    File.open(doc_file, 'r').each_line.select { |line| line.include?("gem 'runeterra_cards'") }.each do |gemline|
      found_gemfile_instructions = true
      next if gemline.include?("'~> #{RuneterraCards::VERSION}'")

      abort <<~ERROR
        gem line in #{doc_file} doesn't match library version
        Expected: #{RuneterraCards::VERSION}
        Actual: #{gemline}
      ERROR
    end

    File.open(doc_file, 'r').each_line
        .select { |line| line.include?("add_dependency 'runeterra_cards'") }.each do |specline|
      found_gemspec_instructions = true
      next if specline.include?("'~> #{RuneterraCards::VERSION}'")

      abort <<~ERROR
        gemspec line in #{doc_file} doesn't match library version
        Expected: #{RuneterraCards::VERSION}
        Actual: #{specline}
      ERROR
    end
  end

  abort "Didn't find Gemfile instructions anywhere!" unless found_gemfile_instructions
  abort "Didn't find gemspec instructions anywhere!" unless found_gemspec_instructions
end

task :check_changelog do
  require 'date'
  expected_entry = "## [#{RuneterraCards::VERSION}] - #{Date.today.iso8601}"

  unless File.open('doc/CHANGELOG.md', 'r').each_line.any? { |line| line.include? expected_entry }
    abort "No entry matching #{expected_entry} found in CHANGELOG"
  end

  if File.open('doc/CHANGELOG.md', 'r').each_line.any? { |line| line.match?(/##.*Unreleased/i) }
    abort "'Unreleased' entry found in CHANGELOG"
  end
end

RuboCop::RakeTask.new

desc 'Verify there are no warnings from Yard documentation generation'
YARD::Rake::YardocTask.new(:verify_docs) do |t|
  t.options = %w[--fail-on-warning --no-output --no-save]
end

desc 'Run all checks (tests, full coverage, style checks)'
task all_checks: %i[test coverage mutation_test rubocop verify_docs]

desc 'Run all fast checks (useful for development)'
task quick_check: %i[test mutation_test_incremental rubocop]

task check_docs_for_release: %i[check_versions_match check_changelog]
task default: :quick_check

task build: %i[all_checks check_docs_for_release]
