require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'
require 'forspell/cli'
require 'mdl'
require 'inch/rake'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)
Reek::Rake::Task.new
Inch::Rake::Suggest.new

PATHS_TO_SPELLCHECK = ['.'].freeze
PATHS_FOR_MDL = ['README.md'].freeze

desc 'Run self spellchecking'
task :spellcheck do |_task|
  Forspell::CLI.new(PATHS_TO_SPELLCHECK).call
end

desc 'Run markdown linter'
task :mdl do |_task|
  MarkdownLint.run(PATHS_FOR_MDL)
end

task default: %i[rubocop reek spellcheck mdl inch spec]
