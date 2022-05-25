module Sami
  module Error
      class UndefinedVariable < StandardError
        def initialize(variable_name)
          super("variable non define #{variable_name}")
        end
      end
  end
end
