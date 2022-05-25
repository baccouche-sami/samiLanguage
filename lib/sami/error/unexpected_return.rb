module Sami
  module Error
      class UnexpectedReturn < StandardError
        def initialize
          super('Unexpected return')
        end
      end
  end
end
