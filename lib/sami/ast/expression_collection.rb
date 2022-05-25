module Sami
  module AST
      module ExpressionCollection
        class_exec do
          attr_accessor :expressions
        end

        def initialize
          @expressions = []
        end

        def <<(expr)
          expressions << expr
        end

        def ==(other)
          expressions == other&.expressions
        end

        def children
          expressions
        end
      end
  end
end
