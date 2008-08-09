require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

task :default => :specs_with_rcov

desc "Run all examples with rcov"
Spec::Rake::SpecTask.new(:specs_with_rcov) do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end

desc "Generate documentation for CIAT"
Rake::RDocTask.new(:doc) do |t|
  t.rdoc_dir = 'doc'
  t.title    = "CIAT"
  t.options << '--line-numbers' << '--inline-source'
  t.options << '--charset' << 'utf-8'
  t.rdoc_files.include('README.txt')
  t.rdoc_files.include('History.txt')
  t.rdoc_files.include('lib/**/*.rb')
end

desc "Make and install gem"
task :gem => [:specs_with_rcov] do
  system "sudo gem uninstall ciat"
  system "gem build ciat.gemspec"
  system "sudo gem install ciat*.gem"
end
