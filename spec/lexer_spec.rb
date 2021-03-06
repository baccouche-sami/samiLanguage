require 'spec_helper'

RSpec.describe Sami::Lexer do
  describe '#start_reading' do
    context 'only one character lexemes' do
      it 'does produce the expected tokens' do
        source = <<-Sami
          ( ) . - + / *
          ! = > <
          \t

          \r
        Sami
        expected_tokens = [:'(', :')', :'.', :'-', :'+', :'/', :'*', :"\n", :'!', :'=', :'>', :'<', :"\n", :eof]
        lexer = Sami::Lexer.new(source)

        lexer.start_reading

        expect(lexer.tokens.map(&:type)).to eq(expected_tokens)
      end
    end

    context 'only two character lexemes' do
      it 'does produce the expected tokens' do
        source = <<-Sami
          != == >= <=
          \t

          \r
        Sami
        expected_tokens = [:'!=', :'==', :'>=', :'<=', :"\n", :eof]
        lexer = Sami::Lexer.new(source)

        lexer.start_reading

        expect(lexer.tokens.map(&:type)).to eq(expected_tokens)
      end
    end

    context 'string literals' do
      it 'does produce the expected token and the expected value' do
        source = <<-Sami
          "Hello world."
        Sami
        expected_token_types = [:string, :"\n", :eof]
        expected_string = Sami::Token.new(:string, '"Hello world."', 'Hello world.', Location.new(0, 10, 14))
        lexer = Sami::Lexer.new(source)

        lexer.start_reading

        expect(lexer.tokens.map(&:type)).to eq(expected_token_types)
        expect(lexer.tokens.first).to eq(expected_string)
      end
    end

    context 'number literals' do
      it 'does produce the expected token and the expected value' do
        source = <<-Sami
          42
          42.42
        Sami
        expected_token_types = [:number, :"\n", :number, :"\n", :eof]
        expected_integer = Sami::Token.new(:number, '42', 42.0, Location.new(0, 10, 2))
        expected_float = Sami::Token.new(:number, '42.42', 42.42, Location.new(1, 23, 5))
        lexer = Sami::Lexer.new(source)

        lexer.start_reading

        expect(lexer.tokens.map(&:type)).to eq(expected_token_types)
        expect(lexer.tokens[0]).to eq(expected_integer)
        expect(lexer.tokens[2]).to eq(expected_float)
      end
    end

    context 'identifiers' do
      it 'does produce the expected tokens' do
        source = <<-Sami
          if true
            my_var = 42
          end
        Sami
        expected_token_types = [:if, :true, :"\n", :identifier, :'=', :number, :"\n", :end, :"\n", :eof]
        i1 = Sami::Token.new(:if, 'if', nil, Location.new(0, 10, 2))
        i2 = Sami::Token.new(:true, 'true', nil, Location.new(0, 13, 4))
        i3 = Sami::Token.new(:identifier, 'my_var', nil, Location.new(1, 30, 6))
        i4 = Sami::Token.new(:end, 'end', nil, Location.new(2, 52, 3))
        lexer = Sami::Lexer.new(source)

        lexer.start_reading

        expect(lexer.tokens.map(&:type)).to eq(expected_token_types)
        expect(lexer.tokens[0]).to eq(i1)
        expect(lexer.tokens[1]).to eq(i2)
        expect(lexer.tokens[3]).to eq(i3)
        expect(lexer.tokens[7]).to eq(i4)
      end
    end

    context 'when the source is a program with valid lexemes only' do
      it 'does produce the appropriate tokens' do
        source = <<-Sami
          fonction sum_integers: first_integer, last_integer
            i = first_integer
            sum = 0
            while i <= last_integer
              sum = sum + i

              i = i + 1
            end

            println(sum)
          end

          sum_integers(1, 100)
        Sami
        lexer = Sami::Lexer.new(source)
        expected_token_types = [
          :fonction, :identifier, :':', :identifier, :',', :identifier, :"\n",
          :identifier, :'=', :identifier, :"\n",
          :identifier, :'=', :number, :"\n",
          :while, :identifier, :'<=', :identifier, :"\n",
          :identifier, :'=', :identifier, :'+', :identifier, :"\n",
          :identifier, :'=', :identifier, :'+', :number, :"\n",
          :end, :"\n",
          :identifier, :'(', :identifier, :')', :"\n",
          :end, :"\n",
          :identifier, :'(', :number, :',', :number, :')', :"\n",
          :eof
        ]

        lexer.start_reading

        expect(lexer.tokens.map(&:type)).to eq(expected_token_types)
      end
    end

    context 'when the source contains unknown characters' do
      it 'does raise an error' do
        source = "my_var = 1\n@"
        lexer = Sami::Lexer.new(source)

        expect { lexer.start_reading }.to raise_error('Unknown character @')
      end
    end
  end
end
