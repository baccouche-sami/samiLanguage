module Sami
  class Interpreter
    attr_reader :program, :output, :env, :call_stack, :unwind_call_stack

    def initialize
      @output = []
      @env = {}
      @call_stack = []
      @unwind_call_stack = -1
    end

    def interpret(ast)
      @program = ast

      interpret_nodes(program.expressions)
    end

    private

    attr_writer :unwind_call_stack

    def println(fn_call)
      return false if fn_call.function_name_as_str != 'println'

      result = interpret_node(fn_call.args.first).to_s
      output << result
      puts result
      true
    end

    def fetch_function_definition(fn_name)
      fn_def = env[fn_name]
      raise Sami::Error::UndefinedFunction.new(fn_name) if fn_def.nil?

      fn_def
    end

    def assign_function_args_to_params(stack_frame)
      fn_def = stack_frame.fn_def
      fn_call = stack_frame.fn_call

      given = fn_call.args.length
      expected = fn_def.params.length
      if given != expected
        raise Sami::Error::WrongNumArg.new(fn_def.function_name_as_str, given, expected)
      end

      if fn_def.params != nil
        fn_def.params.each_with_index do |param, i|
          if env.has_key?(param.name)
            env[param.name] = interpret_node(fn_call.args[i])
          else
            stack_frame.env[param.name] = interpret_node(fn_call.args[i])
          end
        end
      end
    end

    def return_detected?(node)
      node.type == 'return'
    end

    def interpret_nodes(nodes)
      last_value = nil

      nodes.each do |node|
        last_value = interpret_node(node)

        if return_detected?(node)
          raise Sami::Error::UnexpectedReturn unless call_stack.length > 0

          self.unwind_call_stack = call_stack.length 
          return last_value
        end

        if unwind_call_stack == call_stack.length
          return last_value
        elsif unwind_call_stack > call_stack.length
          self.unwind_call_stack = -1
        end
      end

      last_value
    end

    def interpret_node(node)
      interpreter_method = "interpret_#{node.type}"
      send(interpreter_method, node)
    end

    def interpret_identifier(identifier)
      if env.has_key?(identifier.name)
        # Global variable.
        env[identifier.name]
      elsif call_stack.length > 0 && call_stack.last.env.has_key?(identifier.name)
        # Local variable.
        call_stack.last.env[identifier.name]
      else
        # Undefined variable.
        raise Sami::Error::UndefinedVariable.new(identifier.name)
      end
    end

    def interpret_var_binding(var_binding)
      if call_stack.length > 0
        if env.has_key?(var_binding.var_name_as_str)
          env[var_binding.var_name_as_str] = interpret_node(var_binding.right)
        else
          call_stack.last.env[var_binding.var_name_as_str] = interpret_node(var_binding.right)
        end
      else
        env[var_binding.var_name_as_str] = interpret_node(var_binding.right)
      end
    end

    def interpret_conditional(conditional)
      evaluated_cond = interpret_node(conditional.condition)

      if evaluated_cond == nil || evaluated_cond == false
        return nil if conditional.when_false.nil?

        interpret_nodes(conditional.when_false.expressions)
      else
        interpret_nodes(conditional.when_true.expressions)
      end
    end

    def interpret_repetition(repetition)
      while interpret_node(repetition.condition)
        interpret_nodes(repetition.block.expressions)
      end
    end

    def interpret_function_definition(fn_def)
      env[fn_def.function_name_as_str] = fn_def
    end

    def interpret_function_call(fn_call)
      return if println(fn_call)

      fn_def = fetch_function_definition(fn_call.function_name_as_str)

      stack_frame = Sami::StackFrame.new(fn_def, fn_call)

      assign_function_args_to_params(stack_frame)

      # je suis entrain d'executer le body de ma fonction
      call_stack << stack_frame
      value = interpret_nodes(fn_def.body.expressions)
      call_stack.pop
      value
    end

    def interpret_return(ret)
      interpret_node(ret.expression)
    end

    def interpret_unary_operator(unary_op)
      case unary_op.operator
      when :'-'
        -(interpret_node(unary_op.operand))
      else :'!'
        !(interpret_node(unary_op.operand))
      end
    end

    def interpret_binary_operator(binary_op)
      case binary_op.operator
      when :and
        interpret_node(binary_op.left) && interpret_node(binary_op.right)
      when :or
        interpret_node(binary_op.left) || interpret_node(binary_op.right)
      else
        interpret_node(binary_op.left).send(binary_op.operator, interpret_node(binary_op.right))
      end
    end

    def interpret_boolean(boolean)
      boolean.value
    end

    def interpret_nil(nil_node)
      nil
    end

    def interpret_number(number)
      number.value
    end

    def interpret_string(string)
      string.value
    end
  end
end
