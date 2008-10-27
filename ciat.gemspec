Gem::Specification.new do |s|
  s.name     = "ciat"
  s.version  = "0.2.0"
  s.summary  = "Acceptance tester for compilers and interpreters"
  s.email    = "jdfrens@gmail.com"
  s.homepage = "http://github.com/jdfrens/ciat"
  s.description = "CIAT (pronounced \"dog\") is a library of Ruby and rake code to make writing acceptance tests for compilers and interpreters easier (despite their implementation, source, and target languages)."
  s.has_rdoc = true
  s.authors  = ["Jeremy D. Frens", "Mark Van Holstyn"]
  s.files    = 
    ["History.txt", "README.txt", "Rakefile", "ciat.gemspec", 
      "lib/ciat/version.rb"                 ,
      "lib/ciat.rb"                         ,
      "lib/ciat/cargo.rb"                   ,
      "lib/ciat/checked_file.rb",
      "lib/ciat/crate.rb"                   ,
      "lib/ciat/suite.rb"                   ,
      "lib/ciat/test.rb"                    ,
      "lib/ciat/erb_helpers.rb",
      "lib/ciat/traffic_light.rb"           ,
      "lib/ciat/processors/copy.rb"          ,
      "lib/ciat/processors/magister.rb"          ,
      "lib/ciat/compilers/java.rb"          ,
      "lib/ciat/executors/parrot.rb"        ,
      "lib/ciat/differs/html_differ.rb",
      "lib/ciat/feedback/standard_output.rb",
      "lib/ciat/feedback/composite.rb",
      "lib/data/ciat.css",
      "lib/data/prototype.js",
      "lib/templates/report.html.erb"            ,
      "lib/templates/summary_row.html.erb"            ,
      "lib/templates/detail_row.html.erb"            ,
      "lib/templates/detail_row/checked_files.html.erb",
      "lib/templates/detail_row/no_diff.html.erb",
      "lib/templates/detail_row/optional_elements.html.erb",
      "lib/templates/detail_row/source.html.erb",
      ]
  s.extra_rdoc_files = ["README.txt", "History.txt"]
  s.rdoc_options << '--title' << 'CIAT -- Compiler and Interpreter Acceptance Tester' <<
                    '--main' << 'README.txt' <<
                    '--line-numbers'
end
