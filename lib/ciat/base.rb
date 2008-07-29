require 'erb'

module CIAT
  # This is the class to use.
  #
  # You should put all of your tests into files with an <code>.txt</code> into one
  # directory.  Write a +Rakefile+ in that same directory.  CIAT will use a
  # subdirectory named +work+ to do all of its work.  (For now, you may have
  # to create this directory yourself.)
  #
  # The +Rakefile+ should contain a task like this:
  #   task :acceptance_tests do
  #     CIAT::Base.run_tests(make_compiler, make_executor)
  #   end
  #
  # <code>rake acceptance_tests</code> will execute all of your acceptance tests.
  #
  # You do need to define +make_compiler+ and +make_executor+ yourself.  The
  # compiler needs a <code>compile(source_filename, target_filename)</code>
  # which will compile your code; the executor needs a
  # <code>run(target_filename,output_filename)</code> which will execute the
  # generated target code.  See CIAT::Compilers::Java and
  # CIAT::Executors::Parrot.
  class Base
    # The only method in this class that matters to the outside work.  Call
    # this method in your rake task (or anywhere in a Ruby program, I
    # suppose).  It will automatically find all the <code>.txt</code> files as
    # acceptance tests.  Read the class comments above for an example and an
    # explanation of the parameters.
    def self.run_tests(compiler, executor, files = Dir["ciat/*.txt"])
      Dir.mkdir(Filenames.temp_directory) unless File.exist?(Filenames.temp_directory)
      write_file(
        File.join(Filenames.temp_directory, "acceptance.html"), 
        generate_html(run_tests_on_files(files, compiler, executor))
      )
    end
    
    def self.run_tests_on_files(filenames, compiler, executor)
      filenames.map { |filename| run_test(filename, compiler, executor) }      
    end
    
    def self.run_test(filename, compiler, executor)
      CIAT::Test.new(Filenames.new(filename), compiler, executor).run_test
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
