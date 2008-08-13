Gem::Specification.new do |s|
  s.name     = "ciat"
  s.version  = "0.0.4"
  s.summary  = "Acceptance tester for compilers and interpreters"
  s.email    = "jdfrens@gmail.com"
  s.homepage = "http://github.com/jdfrens/ciat"
  s.description = "CIAT (pronounced \"dog\") is a library of Ruby and rake code to make writing acceptance tests for compilers and interpreters easier (despite their implementation, source, and target languages)."
  s.has_rdoc = true
  s.authors  = ["Jeremy D. Frens", "Mark Van Holstyn"]
  s.files    = 
    ["History.txt", "README.txt", "Rakefile", "ciat.gemspec", 
      "lib/ciat/cargo.rb"                   ,
      "lib/ciat/compilers/copy.rb"          ,
      "lib/ciat/compilers/java.rb"          ,
      "lib/ciat/crate.rb"                   ,
      "lib/ciat/executors/cat.rb"           ,
      "lib/ciat/executors/parrot.rb"        ,
      "lib/ciat/feedback/standard_output.rb",
      "lib/ciat/report.html.erb"            ,
      "lib/ciat/suite.rb"                   ,
      "lib/ciat/test.rb"                    ,
      "lib/ciat/traffic_light.rb"           ,
      "lib/ciat/version.rb"                 ,
      "lib/ciat.rb"                         ,
      "lib/data/ciat.css",
      "lib/data/prototype.js"]
  s.extra_rdoc_files = ["README.txt", "History.txt"]
  s.rdoc_options << '--title' << 'CIAT -- Compiler and Interpreter Acceptance Tester' <<
                    '--main' << 'README.txt' <<
                    '--line-numbers'
end
