# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'bundler'
Bundler.require

require 'rake/testtask'
require 'rubocop/rake_task'

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
  sh "bundle exec mutant --include lib --require 'runeterra_cards' --use minitest -- 'RuneterraCards*'"
end

desc 'Incremental mutation testing (tests everything that has changed since the most recent commit)'
task :mutation_test_incremental do
  sh "bundle exec mutant --include lib --require 'runeterra_cards' --use minitest --since HEAD -- 'RuneterraCards*'"
end

RuboCop::RakeTask.new

desc 'Run all checks (tests, full coverage, style checks)'
task all_checks: %i[test coverage mutation_test rubocop]

desc 'Run all fast checks (useful for development)'
task quick_check: %i[test mutation_test_incremental rubocop]

task default: :quick_check
