module CIAT
  class Test
    attr_reader :filenames
    attr_reader :description
    attr_reader :traffic_lights
    attr_reader :hobbes_source
    attr_reader :expected_pir
    attr_reader :expected_output
    
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
      @description, @hobbes_source, @expected_pir, @expected_output = File.read(filenames.test_file).split(/^====\s*$/).map do |s|
        s.gsub(/^\n/, '')
      end
    end
    
    def write_output_files
      write_file(filenames.hobbes_source, hobbes_source)
      write_file(filenames.expected_pir, expected_pir)
      write_file(filenames.expected_output, expected_output)
    end

    def write_file(filename, content)
      File.open(filename, "w") do |file|
        file.write content
      end
    end

    def compile
      @compiler.compile(filenames.hobbes_source, filenames.generated_pir)
    end
    
    def run_program
      @executor.run(filenames.generated_pir, filenames.generated_output)
    end
    
    def check_output
      @traffic_lights[:pir] = do_diff(filenames.expected_pir, filenames.generated_pir, filenames.pir_diff)
      @traffic_lights[:output] = do_diff(filenames.expected_output, filenames.generated_output, filenames.output_diff)
    end
    
    def do_diff(expected, generated, diff)
      system("diff '#{expected}' '#{generated}' > '#{diff}'") ? :green : :red
    end

  end
end
