module CIAT
  class Test
    attr_reader :filenames
    attr_reader :description
    attr_reader :traffic_lights
    attr_reader :source
    attr_reader :compilation_expected
    attr_reader :output_expected
    
    def initialize(filenames, compiler, executor)
      @filenames = filenames
      @compiler = compiler
      @executor = executor
      @traffic_lights = Hash.new
    end
    
    def run_test
      split_test_file
      write_output_files
      compile
      run_program
      check_output
      self
    end
    
    def traffic_light(which)
      if which == :all
        traffic_lights.values.include?(:red) ? :red : :green
      else
        traffic_lights[which]
      end
    end
    
    def split_test_file
      @description, @source, @compilation_expected, @output_expected = File.read(filenames.test_file).split(/^====\s*$/).map do |s|
        s.gsub(/^\n/, '')
      end
    end
    
    def write_output_files
      write_file(filenames.source, source)
      write_file(filenames.compilation_expected, compilation_expected)
      write_file(filenames.output_expected, output_expected)
    end

    def write_file(filename, content)
      File.open(filename, "w") do |file|
        file.write content
      end
    end

    def compile
      @compiler.compile(filenames.source, filenames.compilation_generated)
    end
    
    def run_program
      @executor.run(filenames.compilation_generated, filenames.output_generated)
    end
    
    def check_output
      @traffic_lights[:compilation] = do_diff(filenames.compilation_expected, filenames.compilation_generated, filenames.compilation_diff)
      @traffic_lights[:output] = do_diff(filenames.output_expected, filenames.output_generated, filenames.output_diff)
    end
    
    def do_diff(expected, generated, diff)
      system("diff '#{expected}' '#{generated}' > '#{diff}'") ? :green : :red
    end

  end
end
