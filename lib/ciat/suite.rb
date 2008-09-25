require 'erb'
require 'ciat/erb_helpers'

# = A Suite of Tests
#
# This is the class to use in your +Rakefile+.  The simplest use looks like
# this:
#
#   task :ciat do
#     CIAT::Suite.new(compiler, executor).run
#   end
#
# Define +compiler+ and +executor+ in the +Rakefile+ to return a compiler and
# executor, respectively.  See the "Compilers and Executors" section below.
#
# == Specifying Test and Output Files and Folders
#
# By default, this suite will do the following:
# * find tests ending in <code>.ciat</code> in a folder named
#   <code>ciat</code>,
# * use simple standard-output feedback,
# * put all output files into a folder named <code>temp</code>,
# * produce a report in <code>temp/report.html</code>.
#
# Each of these settings can be overridden with these options:
# * <code>:folder</code> specifies folders to search for test files (default:
#   <code>ciat/**</code>).
# * <code>:pattern</code> specifies a pattern for matching test files
#   (default: <code>*.ciat</code>).
# * <code>:files</code> is an array of specific files (default: none).
# * <code>:output_folder</code> is the output folder (default: +temp+)
# * <code>:report_filename</code> is the name of the report (default:
#   <code>report.html</code> in the output folder)
# * <code>:feedback</code> specifies a feedback mechanism (default: a
#   CIAT::Feedback::StandardOutput).
#
# <code>:folder</code> and <code>:pattern</code> can be used together;
# <code>:files</code> overrides both <code>:folder</code> and
# <code>:pattern</code>.
#
# == Compilers and Executors
#
# You can create your own compiler and executor.  The compiler needs a
# <code>compile(source, compilation_generated)</code> which receives filenames
# and compiles your code; the executor needs an
# <code>execute(compilation_generated, output_generated)</code> which also
# receives filenames and execute the generated target code.  See
# CIAT::Compilers::Java and CIAT::Executors::Parrot (to learn how to use them
# and how to write others).
#
# == Test File
#
# A test file consists of a description, source code, expected target code,
# and expected output.
# * The description is used in feedback and reports.
# * The source code is the code you want compiled by your compiler.
# * The expected target code is the code you expect your compiler to spit out.
# * The expected output is the output you expect when <em>your</em> target
#   code is executed.
#
# For example:
#         
#   Compiles a simple integer.
#   ====
#   2 + 3
#   ====
#   .sub main
#     I0 = 2
#     I1 = 3
#     I0 = I0 + I1
#     print I0
#     print "\n"
#   .end
#   ====
#   5
#
# This example turns the source code <code>2+3</code> into the equivalent PIR
# code (with output).  When the generated PIR code is executed, we expect
# <code>5</code> as a result.
#
class CIAT::Suite
  attr_reader :cargo
  attr_reader :results
  attr_reader :processors
  
  include CIAT::ERBHelpers
  
  # Constructs a suite of CIAT tests.  See the instructions above for possible
  # values for the +options+.
  def initialize(options = {})
    @processors = options[:processors]
    @cargo = options[:cargo] || CIAT::Cargo.new(options)
    @feedback = options[:feedback] || CIAT::Feedback::StandardOutput.new
  end
  
  # Returns the number of tests in the suite.
  def size
    cargo.size
  end
  
  # Runs all of the tests in the suite, and returns the results.  The results
  # are also available through #results.
  def run
    @cargo.copy_suite_data
    @results = cargo.crates.collect { |crate| run_test(crate) }
    generate_report
    @feedback.post_tests(self)
    @results
  end
  
  def run_test(crate) #:nodoc:
    CIAT::Test.new(crate, :processors => test_processors, :feedback => @feedback).run
  end
  
  def test_processors #:nodoc:
    @processors.map { |p| CIAT::Processors::Magister.new(p) }
  end

  def generate_report #:nodoc:
    cargo.write_file(cargo.report_filename, generate_html)
  end
  
  def generate_html #:nodoc:
    ERB.new(CIAT::Suite.template).result(binding)
  end
 
  def self.template #:nodoc:
    File.read(File.join(File.dirname(__FILE__), "..", "templates", "report.html.erb"))
  end
end
