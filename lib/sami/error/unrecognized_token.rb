module Sami
  module Error
      class UnrecognizedToken < StandardError
        attr_reader :unrecognized_token

        def initialize(token)
          @unrecognized_token = token
          message = "Unrecognized token #{unrecognized_token.lexeme}"
          super(message)
        end
    end
  end
end
