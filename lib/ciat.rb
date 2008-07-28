$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'ciat/base'
require 'ciat/test'
require 'ciat/filenames'

# Loads in the basic files needed to use CIAT.  Compilers and executors have to be required separately.
# CIAT::Base is the class you really want to look at.
module CIAT
  
end