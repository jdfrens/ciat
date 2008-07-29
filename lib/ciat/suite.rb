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
  #   task :ciat do
  #     CIAT::Suite.new(compiler, executor).run
  #   end
  #
  # <code>rake ciat</code> will execute all of your acceptance tests.
  #
  # You do need to define +compiler+ and +executor+ yourself.  The
  # compiler needs a <code>compile(source, compilation_generated)</code>
  # which will compile your code; the executor needs a
  # <code>execute(compilation_generated, output_generated)</code> which will execute the
  # generated target code.  See CIAT::Compilers::Java and
  # CIAT::Executors::Parrot.
  class Suite
    attr_reader :filenames
    
    # The only method in this class that matters to the outside work.  Call
    # this method in your rake task (or anywhere in a Ruby program, I
    # suppose).  It will automatically find all the <code>.txt</code> files as
    # acceptance tests.  Read the class comments above for an example and an
    # explanation of the parameters.
    def initialize(compiler, executor, filenames = Dir["ciat/*.txt"])
      @compiler, @executor, @filenames = compiler, executor, filenames
    end
    
    def run
      create_temp_directory

      @results = @filenames.collect do |filename|
        CIAT::Test.new(CIAT::Filenames.new(filename), @compiler, @executor).run
      end
      
      write_file report_filename, generate_html(@results)
      
      @results
    end
    
    def generate_html(test_reports)
      # FIXME: binding here is wrong---very, very wrong!
      ERB.new(template).result(lambda { binding })
    end

    def create_temp_directory
      Dir.mkdir(CIAT::Filenames.temp_directory) unless File.exist?(CIAT::Filenames.temp_directory)
    end
    
    def write_file(filename, content)
      File.open(filename, "w") do |file|
        file.write content
      end
    end
        
    def report_filename
      File.join(Filenames.temp_directory, "ciat.html")
    end

    def template
      File.read(File.dirname(__FILE__) + "/report.erb.html").gsub(/^  /, '')
    end
  end
end
