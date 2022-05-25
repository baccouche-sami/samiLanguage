class Sami::AST::Identifier < Sami::AST::Expression
  attr_accessor :name

  EXPECTED_NEXT_TOKENS = [
    :"\n",
    :+,
    :-,
    :*,
    :/,
    :==,
    :!=,
    :>,
    :<,
    :>=,
    :<=,
    :and,
    :or
  ].freeze

  def initialize(name)
    @name = name
  end

  def ==(other)
    name == other&.name
  end

  def children
    []
  end

  def expects?(next_token)
    EXPECTED_NEXT_TOKENS.include?(next_token)
  end
end
