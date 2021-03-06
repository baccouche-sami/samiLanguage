require 'spec_helper'

RSpec.describe Sami::Parser do
  sfe_prog = Sami::AST::Program
  sfe_expr = Sami::AST::Expression
  sfe_var_binding = Sami::AST::VarBinding
  sfe_ident = Sami::AST::Identifier
  sfe_str = Sami::AST::String
  sfe_num = Sami::AST::Number
  sfe_bool = Sami::AST::Boolean
  sfe_nil = Sami::AST::Nil
  sfe_return = Sami::AST::Return
  sfe_unary_op = Sami::AST::UnaryOperator
  sfe_binary_op = Sami::AST::BinaryOperator
  sfe_conditional = Sami::AST::Conditional
  sfe_repetition = Sami::AST::Repetition
  sfe_block = Sami::AST::Block
  sfe_fn_def = Sami::AST::FunctionDefinition
  sfe_fn_call = Sami::AST::FunctionCall

  describe '#parse' do
    context 'variable binding' do
      it 'does generate the expected AST when the syntax is followed' do
        ident = sfe_ident.new('my_var')
        num = sfe_num.new(1.0)
        var_binding = sfe_var_binding.new(ident, num)
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(var_binding)
        parser = Sami::Parser.new(tokens_from_source('var_binding_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does result in a syntax error when the syntax is not respected' do
        parser = Sami::Parser.new(tokens_from_source('var_binding_err_1.sami'))

        parser.parse

        expect(parser.errors.length).to eq(1)
        expect(parser.errors.last.next_token.lexeme).to eq('1')
      end
    end

    context 'standalone identifier' do
      it 'does generate the expected AST' do
        ident = sfe_ident.new('my_var')
        var_binding = sfe_var_binding.new(ident, sfe_num.new(1.0))
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(var_binding, ident)
        parser = Sami::Parser.new(tokens_from_source('standalone_identifier_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'standalone number' do
      it 'does generate the expected AST' do
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(sfe_num.new(1991.0), sfe_num.new(7.0), sfe_num.new(28.28))
        parser = Sami::Parser.new(tokens_from_source('standalone_number_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'standalone string' do
      it 'does generate the expected AST' do
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(sfe_str.new('a string'), sfe_str.new('another string'))
        parser = Sami::Parser.new(tokens_from_source('standalone_string_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end


    context 'standalone boolean' do
      it 'does generate the expected AST' do
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(sfe_bool.new(true), sfe_bool.new(false))
        parser = Sami::Parser.new(tokens_from_source('standalone_boolean_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'boolean expressions' do
      it 'does generate the expected AST for 1 == 1' do
        expected_prog = sfe_prog.new
        comparison_op = sfe_binary_op.new(:'==', sfe_num.new(1.0), sfe_num.new(1.0))

        expected_prog.expressions.append(comparison_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_7.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 2 != 1' do
        expected_prog = sfe_prog.new
        comparison_op = sfe_binary_op.new(:'!=', sfe_num.new(2.0), sfe_num.new(1.0))

        expected_prog.expressions.append(comparison_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_6.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 2 + 2 > 3' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), sfe_num.new(2.0))
        comparison_op = sfe_binary_op.new(:'>', plus_op, sfe_num.new(3.0))

        expected_prog.expressions.append(comparison_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_5.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 2 + 2 >= 3' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), sfe_num.new(2.0))
        comparison_op = sfe_binary_op.new(:'>=', plus_op, sfe_num.new(3.0))

        expected_prog.expressions.append(comparison_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_4.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 3 < 2 + 2' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), sfe_num.new(2.0))
        comparison_op = sfe_binary_op.new(:'<', sfe_num.new(3.0), plus_op)

        expected_prog.expressions.append(comparison_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_3.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 3 <= 2 + 2' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), sfe_num.new(2.0))
        comparison_op = sfe_binary_op.new(:'<=', sfe_num.new(3.0), plus_op)

        expected_prog.expressions.append(comparison_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for true != false' do
        expected_prog = sfe_prog.new
        not_eq_op = sfe_binary_op.new(:'!=', sfe_bool.new(true), sfe_bool.new(false))
        expected_prog.expressions.append(not_eq_op)
        parser = Sami::Parser.new(tokens_from_source('boolean_expr_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'standalone nil' do
      it 'does generate the expected AST' do
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(sfe_nil.new)
        parser = Sami::Parser.new(tokens_from_source('standalone_nil_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'unary operators' do
      it 'does generate the expected AST' do
        expected_prog = sfe_prog.new
        minus_op_1 = sfe_unary_op.new(:'-', sfe_num.new(28.0))
        minus_op_2 = sfe_unary_op.new(:'-', sfe_num.new(24.42))
        bang_op = sfe_unary_op.new(:'!', sfe_num.new(7.0))
        expected_prog.expressions.append(minus_op_1, minus_op_2, bang_op)
        parser = Sami::Parser.new(tokens_from_source('unary_operator_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'binary operators' do
      it 'does generate the expected AST for 2 + 2' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), sfe_num.new(2.0))
        expected_prog.expressions.append(plus_op)
        parser = Sami::Parser.new(tokens_from_source('binary_operator_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 2 + 2 * 3' do
        expected_prog = sfe_prog.new
        multiplication_op = sfe_binary_op.new(:'*', sfe_num.new(2.0), sfe_num.new(3.0))
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), multiplication_op)
        expected_prog.expressions.append(plus_op)
        parser = Sami::Parser.new(tokens_from_source('binary_operator_ok_2.sami'))

        parser.parse

        # expected: 2 + (2 * 3)
        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for 2 + 2 * 3 / 3' do
        expected_prog = sfe_prog.new
        multiplication_op = sfe_binary_op.new(:'*', sfe_num.new(2.0), sfe_num.new(3.0))
        division_op = sfe_binary_op.new(:'/', multiplication_op, sfe_num.new(3.0))
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(2.0), division_op)
        expected_prog.expressions.append(plus_op)
        parser = Sami::Parser.new(tokens_from_source('binary_operator_ok_3.sami'))

        parser.parse

        # expected: 2 + ((2 * 3) / 3)
        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'mixed operators' do
      it 'does generate the expected AST for -10 + 2 + 2 * 3 / 3' do
        expected_prog = sfe_prog.new
        inversion_op = sfe_unary_op.new(:'-', sfe_num.new(10.0))
        plus_op_1 = sfe_binary_op.new(:'+', inversion_op, sfe_num.new(2.0))
        multiplication_op = sfe_binary_op.new(:'*', sfe_num.new(2.0), sfe_num.new(3.0))
        division_op = sfe_binary_op.new(:'/', multiplication_op, sfe_num.new(3.0))
        plus_op_2 = sfe_binary_op.new(:'+', plus_op_1, division_op)
        expected_prog.expressions.append(plus_op_2)
        parser = Sami::Parser.new(tokens_from_source('mixed_operator_ok_1.sami'))

        parser.parse

        # expected: (-10 + 2) + ((2 * 3) / 3)
        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'logical operators' do
      it 'does generate the expected AST for true and false' do
        expected_prog = sfe_prog.new
        and_op = sfe_binary_op.new(:and, sfe_bool.new(true), sfe_bool.new(false))
        expected_prog.expressions.append(and_op)
        parser = Sami::Parser.new(tokens_from_source('logical_operator_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for true or false' do
        expected_prog = sfe_prog.new
        or_op = sfe_binary_op.new(:or, sfe_bool.new(true), sfe_bool.new(false))
        expected_prog.expressions.append(or_op)
        parser = Sami::Parser.new(tokens_from_source('logical_operator_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for true and false or true' do
        expected_prog = sfe_prog.new
        and_op = sfe_binary_op.new(:and, sfe_bool.new(true), sfe_bool.new(false))
        or_op = sfe_binary_op.new(:or, and_op, sfe_bool.new(true))
        expected_prog.expressions.append(or_op)
        parser = Sami::Parser.new(tokens_from_source('logical_operator_ok_3.sami'))

        parser.parse

        # expected: (true and false) or true
        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'grouped expressions' do
      it 'does generate the expected AST for (3 + 4) * 2' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(3.0), sfe_num.new(4.0))
        multiplication_op = sfe_binary_op.new(:'*', plus_op, sfe_num.new(2.0))
        expected_prog.expressions.append(multiplication_op)
        parser = Sami::Parser.new(tokens_from_source('grouped_expr_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for ((4 + 4) / 4) * 2' do
        expected_prog = sfe_prog.new
        plus_op = sfe_binary_op.new(:'+', sfe_num.new(4.0), sfe_num.new(4.0))
        division_op = sfe_binary_op.new(:'/', plus_op, sfe_num.new(4.0))
        multiplication_op = sfe_binary_op.new(:'*', division_op, sfe_num.new(2.0))
        expected_prog.expressions.append(multiplication_op)
        parser = Sami::Parser.new(tokens_from_source('grouped_expr_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for true and (false or true)' do
        expected_prog = sfe_prog.new
        or_op = sfe_binary_op.new(:or, sfe_bool.new(false), sfe_bool.new(true))
        and_op = sfe_binary_op.new(:and, sfe_bool.new(true), or_op)
        expected_prog.expressions.append(and_op)
        parser = Sami::Parser.new(tokens_from_source('grouped_expr_ok_3.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'return' do
      it 'does generate the expected AST' do
        ret = sfe_return.new(sfe_num.new(1.0))
        expected_prog = sfe_prog.new
        expected_prog.expressions.append(ret)
        parser = Sami::Parser.new(tokens_from_source('return_ok.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'conditionals' do
      it 'does generate the expected AST for a IF THEN conditional' do
        expected_prog = sfe_prog.new
        ident = sfe_ident.new('world_still_makes_sense')
        var_binding_outer = sfe_var_binding.new(ident, sfe_bool.new(false))
        eq_op = sfe_binary_op.new(:'==', sfe_num.new(1.0), sfe_num.new(1.0))
        var_binding_inner = sfe_var_binding.new(ident, sfe_bool.new(true))
        true_block = sfe_block.new
        true_block.expressions.append(var_binding_inner)
        conditional = sfe_conditional.new(eq_op, true_block)
        expected_prog.expressions.append(var_binding_outer, conditional)
        parser = Sami::Parser.new(tokens_from_source('conditional_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for a IF THEN ELSE conditional' do
        expected_prog = sfe_prog.new

        ident_1 = sfe_ident.new('world_still_makes_sense')
        ident_2 = sfe_ident.new('world_gone_mad')
        var_binding_1 = sfe_var_binding.new(ident_1, sfe_bool.new(false))
        var_binding_2 = sfe_var_binding.new(ident_2, sfe_bool.new(false))

        eq_op = sfe_binary_op.new(:'==', sfe_num.new(1.0), sfe_num.new(1.0))
        var_binding_3 = sfe_var_binding.new(ident_1, sfe_bool.new(true))
        true_block = sfe_block.new
        true_block.expressions.append(var_binding_3)

        ineq_op = sfe_binary_op.new(:'!=', sfe_num.new(1.0), sfe_num.new(1.0))
        var_binding_4 = sfe_var_binding.new(ident_2, sfe_bool.new(true))
        false_block = sfe_block.new
        false_block.expressions.append(ineq_op, var_binding_4)

        conditional = sfe_conditional.new(eq_op, true_block, false_block)

        expected_prog.expressions.append(var_binding_1, var_binding_2, conditional)
        parser = Sami::Parser.new(tokens_from_source('conditional_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for a IF THEN ELSE IF conditional' do
        expected_prog = sfe_prog.new

        ident_1 = sfe_ident.new('world_still_makes_sense')
        ident_2 = sfe_ident.new('world_gone_mad')
        var_binding_1 = sfe_var_binding.new(ident_1, sfe_bool.new(false))
        var_binding_2 = sfe_var_binding.new(ident_2, sfe_bool.new(false))

        eq_op = sfe_binary_op.new(:'==', sfe_num.new(1.0), sfe_num.new(1.0))
        var_binding_3 = sfe_var_binding.new(ident_1, sfe_bool.new(true))
        true_block = sfe_block.new
        true_block.expressions.append(var_binding_3)

        var_binding_4 = sfe_var_binding.new(ident_2, sfe_bool.new(true))
        true_block_inner = sfe_block.new
        true_block_inner.expressions.append(var_binding_4)
        conditional_inner = sfe_conditional.new(sfe_bool.new(true), true_block_inner)
        false_block = sfe_block.new
        false_block.expressions.append(conditional_inner)

        conditional_outer = sfe_conditional.new(eq_op, true_block, false_block)

        expected_prog.expressions.append(var_binding_1, var_binding_2, conditional_outer)
        parser = Sami::Parser.new(tokens_from_source('conditional_ok_3.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'repetitions' do
      it 'does generate the expected AST for a WHILE loop' do
        expected_prog = sfe_prog.new
        ident = sfe_ident.new('i')
        var_binding_outer = sfe_var_binding.new(ident, sfe_num.new(0.0))
        lt_op = sfe_binary_op.new(:'<', ident, sfe_num.new(10.0))
        fn_call = sfe_fn_call.new(sfe_ident.new('do_something'), [])
        var_binding_inner = sfe_var_binding.new(ident, sfe_binary_op.new(:'+', ident, sfe_num.new(1.0)))
        repetition_block = sfe_block.new
        repetition_block.expressions.append(fn_call, var_binding_inner)
        repetition = sfe_repetition.new(lt_op, repetition_block)
        expected_prog.expressions.append(var_binding_outer, repetition)
        parser = Sami::Parser.new(tokens_from_source('repetition_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'function definition' do
      it 'does generate the expected AST for a function without parameters' do
        expected_prog = sfe_prog.new

        block_1 = sfe_block.new
        block_1 << sfe_num.new(1.0)
        ident_1 = sfe_ident.new('one')
        fn_def_1 = sfe_fn_def.new(ident_1, [], block_1)

        block_2 = sfe_block.new
        block_2 << sfe_num.new(2.0)
        ident_2 = sfe_ident.new('two')
        fn_def_2 = sfe_fn_def.new(ident_2, [], block_2)

        expected_prog.expressions.append(fn_def_1, fn_def_2)
        parser = Sami::Parser.new(tokens_from_source('fn_def_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for a function with one parameter' do
        expected_prog = sfe_prog.new
        fn_name = sfe_ident.new('double')
        param = sfe_ident.new('num')
        block = sfe_block.new
        block << sfe_binary_op.new(:'*', param, sfe_num.new(2.0))
        fn_def = sfe_fn_def.new(fn_name, [param], block)
        expected_prog.expressions.append(fn_def)
        parser = Sami::Parser.new(tokens_from_source('fn_def_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for a function with multiple parameters' do
        expected_prog = sfe_prog.new
        fn_name = sfe_ident.new('sum_3')
        param_1 = sfe_ident.new('num_1')
        param_2 = sfe_ident.new('num_2')
        param_3 = sfe_ident.new('num_3')
        plus_op_left = sfe_binary_op.new(:'+', param_1, param_2)
        plus_op_right = sfe_binary_op.new(:'+', plus_op_left, param_3)
        block = sfe_block.new
        block << plus_op_right
        fn_def = sfe_fn_def.new(fn_name, [param_1, param_2, param_3], block)
        expected_prog.expressions.append(fn_def)
        parser = Sami::Parser.new(tokens_from_source('fn_def_ok_3.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'function call' do
      it 'does generate the expected AST for a call with no arguments' do
        expected_prog = sfe_prog.new
        ident = sfe_ident.new('my_func')
        fn_call = sfe_fn_call.new(ident, [])
        expected_prog.expressions.append(fn_call)
        parser = Sami::Parser.new(tokens_from_source('fn_call_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for a call with one argument' do
        expected_prog = sfe_prog.new
        ident = sfe_ident.new('my_func')
        args = [sfe_num.new(1.0)]
        fn_call = sfe_fn_call.new(ident, args)
        expected_prog.expressions.append(fn_call)
        parser = Sami::Parser.new(tokens_from_source('fn_call_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does generate the expected AST for a call with multiple arguments' do
        expected_prog = sfe_prog.new
        ident = sfe_ident.new('my_func')
        args = [sfe_num.new(1.0), sfe_ident.new('my_arg'), sfe_binary_op.new(:'+', sfe_num.new(2.0), sfe_num.new(2.0))]
        fn_call = sfe_fn_call.new(ident, args)
        expected_prog.expressions.append(fn_call)
        parser = Sami::Parser.new(tokens_from_source('fn_call_ok_3.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end

    context 'complex programs' do
      it 'does produce the expected AST for a program that sums all integers between (inclusive) two numbers' do
        expected_prog = sfe_prog.new
        fn_name = sfe_ident.new('sum_integers')
        fn_param_1 = sfe_ident.new('first_integer')
        fn_param_2 = sfe_ident.new('last_integer')
        fn_body = sfe_block.new

        ident_1 = sfe_ident.new('i')
        var_binding_1 = sfe_var_binding.new(ident_1, fn_param_1)
        ident_2 = sfe_ident.new('sum')
        var_binding_2 = sfe_var_binding.new(ident_2, sfe_num.new(0.0))

        repetition_condition = sfe_binary_op.new(:'<=', ident_1, fn_param_2)
        var_binding_3 = sfe_var_binding.new(ident_2, sfe_binary_op.new(:'+', ident_2, ident_1))
        var_binding_4 = sfe_var_binding.new(ident_1, sfe_binary_op.new(:'+', ident_1, sfe_num.new(1.0)))
        repetition_block = sfe_block.new
        repetition_block.expressions.append(var_binding_3, var_binding_4)
        repetition = sfe_repetition.new(repetition_condition, repetition_block)

        println = sfe_fn_call.new(sfe_ident.new('println'), [ident_2])

        fn_body.expressions.append(var_binding_1, var_binding_2, repetition, println)
        fn_def = sfe_fn_def.new(fn_name, [fn_param_1, fn_param_2], fn_body)
        fn_call = sfe_fn_call.new(fn_name, [sfe_num.new(1.0), sfe_num.new(100.0)])

        expected_prog.expressions.append(fn_def, fn_call)
        parser = Sami::Parser.new(tokens_from_source('complex_program_ok_1.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end

      it 'does produce the expected AST for a program that calculates the double of a number' do
        expected_prog = sfe_prog.new
        fn_name = sfe_ident.new('double')
        fn_param_1 = sfe_ident.new('num')
        fn_body = sfe_block.new
        binary_op = sfe_binary_op.new(:'*', fn_param_1, sfe_num.new(2.0))
        fn_body.expressions.append(binary_op)
        fn_def = sfe_fn_def.new(fn_name, [fn_param_1], fn_body)
        expected_prog.expressions.append(fn_def)
        parser = Sami::Parser.new(tokens_from_source('complex_program_ok_2.sami'))

        parser.parse

        expect(parser.ast).to eq(expected_prog)
      end
    end
  end

  def tokens_from_source(filename)
    source = File.read(Pathname.new(__dir__).join('..', '..','SamiLanguage','spec','fixtures', 'parser', filename))

    Sami::Lexer.new(source).start_reading
  end
end
