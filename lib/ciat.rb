$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'ciat/base'
require 'ciat/test'
require 'ciat/filenames'

module CIAT
  
end