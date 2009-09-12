$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# Loads in the basic files needed to use CIAT.  Compilers and Executors have
# to be required separately. CIAT::Suite is the class you really want to look
# at.
module CIAT; end

require 'ciat/rake_task'
require 'ciat/traffic_light'
require 'ciat/suite'
require 'ciat/test'
require 'ciat/test_element'
require 'ciat/cargo'
require 'ciat/crate'
require 'ciat/feedback/standard_output'
require 'ciat/feedback/html_feedback'
require 'ciat/differs/html_differ'
require 'ciat/processors/basic_processing'
require 'ciat/processors/compiler'
require 'ciat/processors/interpreter'
require 'ciat/processors/compilation_interpreter'
