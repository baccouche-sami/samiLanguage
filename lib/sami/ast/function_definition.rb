class Sami::AST::FunctionDefinition < Sami::AST::Expression
  attr_accessor :name, :params, :body

  def initialize(fn_name = nil, fn_params = [], fn_body = nil)
    @name = fn_name
    @params = fn_params
    @body = fn_body
  end

  def function_name_as_str
    name.name
  end

  def ==(other)
    children == other&.children
  end

  def children
    [name, params, body]
  end
end
