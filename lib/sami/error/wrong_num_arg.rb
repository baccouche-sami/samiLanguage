module Sami
  module Error
      class WrongNumArg < StandardError
        def initialize(fn_name, num_arg_given, num_arg_expected)
          super("#{fn_name}(): incorrect nombre des args (find #{num_arg_given}, expected #{num_arg_expected})")
        end
      end
  end
end
