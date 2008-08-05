require 'erb'

# This is the class to use.
#
# Put all of your tests into <code>.ciat</code> files in a <code>ciat</code> directory. 
#
# CIAT will use a subdirectory named +temp+ to do all of its work.
#
# Add a rake task to your +Rakefile+ (or create a +Rakefile+ if needed)
#
# Your +Rakefile+ should contain a task like this:
#   task :ciat do
#     CIAT::Suite.new(CIAT::Compilers::Java.new(classpath, compiler_class), CIAT::Executors::Parrot.new).run
#   end
#
# <code>rake ciat</code> will execute all of your acceptance tests.
#
# You can create your own compiler and executor.  The
# compiler needs a <code>compile(source, compilation_generated)</code>
# which will compile your code; the executor needs an
# <code>execute(compilation_generated, output_generated)</code> which will execute the
# generated target code.  See CIAT::Compilers::Java and
# CIAT::Executors::Parrot.
class CIAT::Suite
  attr_reader :testnames
  attr_reader :folder
  
  # The only method in this class that matters to the outside work.  Call
  # this method in your rake task (or anywhere in a Ruby program, I
  # suppose).  It will automatically find all the <code>ciat/*.ciat</code> files as
  # acceptance tests.  Read the class comments above for an example and an
  # explanation of the parameters.
  def initialize(compiler, executor, options = {})
    @compiler, @executor = compiler, executor
    @folder = options[:folder]
    @testnames = options[:testnames] || default_testnames(@folder)
    @feedback = options[:feedback] || CIAT::Feedback::StandardOutput.new
  end
  
  def size
    testnames.size
  end
  
  def run
    create_temp_directory
    results = @testnames.collect { |testname| run_test(testname) }
    write_file report_filename, generate_html(results)
    @feedback.post_tests(self)
    results
  end
  
  def run_test(testname)
    CIAT::Test.new(CIAT::CiatNames.new(testname), @compiler, @executor).run
  end
  
  def generate_html(test_reports)
    # FIXME: binding here is wrong---very, very wrong!
    ERB.new(template).result(lambda { binding })
  end

  def create_temp_directory
    Dir.mkdir(CIAT::CiatNames.temp_directory) unless File.exist?(CIAT::CiatNames.temp_directory)
  end
  
  def write_file(filename, content)
    File.open(filename, "w") do |file|
      file.write content
    end
  end
      
  def report_filename
    File.join(CIAT::CiatNames.temp_directory, "ciat.html")
  end

  def template
    File.read(File.dirname(__FILE__) + "/report.html.erb").gsub(/^  /, '')
  end
  
  private
  def default_testnames(folder)
    Dir[File.join(["ciat", folder, "*.ciat"].compact)]
  end
end
