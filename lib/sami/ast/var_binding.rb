class Sami::AST::VarBinding < Sami::AST::Expression
  attr_accessor :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def var_name_as_str
    left.name
  end

  def ==(other)
    children == other&.children
  end

  def children
    [left, right]
  end
end
