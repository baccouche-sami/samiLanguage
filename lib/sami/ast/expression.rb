module Sami
  module AST
    class Expression
      attr_accessor :value

      def initialize(val = nil)
        @value = val
      end
      def underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end

      def ==(other)
        self.class == other.class
      end

      def children
        []
      end

      def type
        underscore(self.class.to_s.split('::').last)
      end
    end
  end
end
