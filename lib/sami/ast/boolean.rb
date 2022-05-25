class Sami::AST::Boolean < Sami::AST::Expression
  def initialize(val)
    super(val)
  end

  def ==(other)
    value == other&.value
  end

  def children
    []
  end
end
