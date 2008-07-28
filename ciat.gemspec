Gem::Specification.new do |s|
  s.name     = "ciat"
  s.version  = "0.0.2"
  s.summary  = "Acceptance tester for compilers and interpreters"
  s.email    = "jdfrens@gmail.com"
  s.homepage = "http://github.com/jdfrens/ciat"
  s.description = "CIAT (pronounced \"dog\") is a library of Ruby and rake code to make writing acceptance tests for compilers and interpreters easier (despite their implementation, source, and target languages)."
  s.has_rdoc = true
  s.authors  = ["Jeremy D. Frens"]
  s.files    = ["History.txt",
		"README.txt", 
		"Rakefile", 
		"ciat.gemspec", 
		"lib/ciat/base.rb", 
		"lib/ciat/compiler_in_java.rb", 
		"lib/ciat/executor_of_parrot.rb",
		"lib/ciat/filenames.rb", 
		"lib/ciat/report.erb.html",
		"lib/ciat/test.rb", 
		"lib/ciat/version.rb", 
		"lib/ciat.rb"]
  s.extra_rdoc_files = ["README.txt", "History.txt"]
  s.rdoc_options << '--title' << 'CIAT -- Compiler and Interpreter Acceptance Tester' <<
                    '--main' << 'README.txt' <<
                    '--line-numbers'
end
