require 'erb'

module CIAT
  class Base
    def self.run_tests(compiler, executor)
      write_file("acceptance.html", generate_html(run_tests_on_files(Dir.glob("*.txt"), compiler, executor)))
    end
    
    def self.run_tests_on_files(filenames, compiler, executor)
      filenames.map { |filename| run_test(filename, compiler, executor) }      
    end
    
    def self.run_test(filename, compiler, executor)
      CIAT::Test.new(Filenames.new(filename.gsub(/\.txt$/, '')), compiler, executor).run_test
    end
    
    def self.write_file(filename, content)
      File.open(filename, "w") do |file|
        file.write content
      end
    end
    
    def self.generate_html(test_reports)
      # FIXME: binding here is wrong---very, very wrong!
      ERB.new(template).result(lambda { binding })
    end

    def self.template
      File.read(File.dirname(__FILE__) + "/report.erb.html").gsub(/^  /, '')
    end
  end
end
