module Sami
  module Error
      class UndefinedFunction < StandardError
        def initialize(fn_name)
          super("Fonction non define #{fn_name}")
        end
      end
  end
end
