require 'rake'
require 'rake/clean'
require 'rake/rdoctask'
require 'spec/rake/spectask'

task :default => :specs

desc "Run all examples"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc "Run all examples with rcov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
  end
end

desc "Generate documentation for CIAT"
Rake::RDocTask.new(:doc) do |t|
  t.rdoc_dir = 'doc'
  t.title    = "CIAT"
  t.options << '--line-numbers' << '--inline-source'
  t.options << '--charset' << 'utf-8'
  t.rdoc_files.include('README.rdoc')
  t.rdoc_files.include('History.txt')
  t.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name     = "ciat"
    gemspec.summary  = "Acceptance tester for compilers and interpreters"
    gemspec.email    = "jdfrens@gmail.com"
    gemspec.homepage = "http://github.com/jdfrens/ciat"
    gemspec.description = "CIAT (pronounced \"dog\") is a library of Ruby and rake code to make writing acceptance tests for compilers and interpreters easier (despite their implementation, source, and target languages)."
    gemspec.files = Dir['lib/**/*.rb']
    gemspec.has_rdoc = true
    gemspec.authors  = ["Jeremy D. Frens", "Mark Van Holstyn"]
    gemspec.rdoc_options <<
      '--title' << 'CIAT -- Compiler and Interpreter Acceptance Tester' <<
      '--main' << 'README.txt' <<
      '--line-numbers'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

CLOBBER << FileList['*.gem']
