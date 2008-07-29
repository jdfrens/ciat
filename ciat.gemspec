Gem::Specification.new do |s|
  s.name     = "ciat"
  s.version  = "0.0.1"
  s.date     = "2008-07-27"
  s.summary  = "Acceptance tester for compilers and interpreters"
  s.email    = "jdfrens@gmail.com"
  s.homepage = "http://github.com/jdfrens/ciat"
  s.description = "CIAT (pronounced \"dog\") is a library of Ruby and rake code to make writing acceptance tests for compilers and interpreters easier (despite their implementation, source, and target languages)."
  s.has_rdoc = true
  s.authors  = ["Jeremy D. Frens", "Mark Van Holstyn"]
  s.files    = ["History.txt",
		"README.txt", 
		"Rakefile", 
		"ciat.gemspec", 
		"lib/ciat/suite.rb", 
		"lib/ciat/compilers/java.rb", 
		"lib/ciat/executors/parrot.rb",
		"lib/ciat/filenames.rb", 
		"lib/ciat/report.erb.html",
		"lib/ciat/test.rb", 
		"lib/ciat/version.rb", 
		"lib/ciat.rb"]
  s.rdoc_options = ["README.txt"]
  s.extra_rdoc_files = ["History.txt", "README.txt"]
end
