module CIAT::Processors
  module BasicProcessing
    # FIXME: need unit tests
    def relevant_elements(crate)
      relevant_names.map { |name| crate.element?(name) ? crate.element(name) : nil }.compact
    end
  
    # FIXME: need unit tests, need flexibility (see parrot)
    def relevant_names
      case light.setting
      when :green
        [:source, :execution]
      when :yellow
        [:source, :execution_generated]
      when :red
        [:source, :execution_diff]
      else
        raise "unexpected setting #{light.setting}"
      end
    end
  
  end
end