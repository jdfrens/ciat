require 'erb'
require 'ciat/feedback/composite'
require 'ciat/feedback/feedback_counter'
require 'ciat/feedback/return_status'
require 'ciat/suite_builder'

# = A Suite of Tests
#
# This is the top-level class for organizing CIAT tests.  It can be used in a
# +Rakefile+ like so:
#
#   task :ciat do
#     CIAT::Suite.new(:processors => [compiler, executor]).run
#   end
#
# You may find the CIAT::RakeTask a little bit easier and more familiar 
# to use.
#
# == Specifying Test and Output Files and Folders
#
# By default, this suite will do the following:
# * find tests ending in <code>.ciat</code> in a folder named
#   <code>ciat</code>,
# * use simple standard-output feedback,
# * put all output files into a folder named <code>temp</code>,
# * produce an HTML report in <code>temp/report.html</code>.
#
# Each of these settings can be overridden with these options:
# * <code>:processors</code> is <em>required</em> and specifies the processors
#   to be executed; order matters!
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
# == Processors
#
# You can create your own processors.  Each processor needs to specify which
# test elements it wants or will accept, which files it wants checked, and how
# it should be executed.    See CIAT::Compilers::Java and
# CIAT::Executors::Parrot (to learn how to use them and how to write others).
#
# == Test File
#
# See the README for details on the format of a test file.
#
class CIAT::Suite
  
  attr_reader :processors
  attr_reader :output_folder
  attr_reader :test_files
  attr_reader :results
  
  # Constructs a suite of CIAT tests.  See the instructions above for possible
  # values for the +options+.
  def initialize(options = {})
    builder = CIAT::SuiteBuilder.new(options)
    @processors = builder.build_processors
    @output_folder = builder.build_output_folder
    @test_files = builder.build_test_files
    @feedback = builder.build_feedback
  end
    
  # Returns the number of tests in the suite.
  def size
    test_files.size
  end
  
  # Runs all of the tests in the suite, and returns the results.  The results
  # are also available through #results.
  def run
    @feedback.pre_tests(self)
    @results = test_files.
      map { |test_file| create_test(test_file) }.
      map { |test| test.run }
    @feedback.post_tests(self)
    @results
  end
  
  def create_test(test_file)
    CIAT::Test.new(test_file,
      test_file.process_test_file,
      :processors => test_processors,
      :feedback => @feedback)
  end
  
  def test_processors #:nodoc:
    @processors.map { |processor| processor.for_test }
  end

end
