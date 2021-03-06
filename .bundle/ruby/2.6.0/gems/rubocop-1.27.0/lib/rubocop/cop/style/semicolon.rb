# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks for multiple expressions placed on the same line.
      # It also checks for lines terminated with a semicolon.
      #
      # This cop has `AllowAsExpressionSeparator` configuration option.
      # It allows `;` to separate several expressions on the same line.
      #
      # @example
      #   # bad
      #   foo = 1; bar = 2;
      #   baz = 3;
      #
      #   # good
      #   foo = 1
      #   bar = 2
      #   baz = 3
      #
      # @example AllowAsExpressionSeparator: false (default)
      #   # bad
      #   foo = 1; bar = 2
      #
      # @example AllowAsExpressionSeparator: true
      #   # good
      #   foo = 1; bar = 2
      class Semicolon < Base
        include RangeHelp
        extend AutoCorrector

        MSG = 'Do not use semicolons to terminate expressions.'

        def self.autocorrect_incompatible_with
          [Style::SingleLineMethods]
        end

        def on_new_investigation
          return if processed_source.blank?

          check_for_line_terminator_or_opener
        end

        def on_begin(node)
          return if cop_config['AllowAsExpressionSeparator']

          exprs = node.children

          return if exprs.size < 2

          expressions_per_line(exprs).each do |line, expr_on_line|
            # Every line with more than one expression on it is a
            # potential offense
            next unless expr_on_line.size > 1

            find_semicolon_positions(line) { |pos| register_semicolon(line, pos, true) }
          end
        end

        private

        def check_for_line_terminator_or_opener
          # Make the obvious check first
          return unless processed_source.raw_source.include?(';')

          each_semicolon { |line, column| register_semicolon(line, column, false) }
        end

        def each_semicolon
          tokens_for_lines.each do |line, tokens|
            yield line, tokens.last.column if tokens.last.semicolon?
            yield line, tokens.first.column if tokens.first.semicolon?
          end
        end

        def tokens_for_lines
          processed_source.tokens.group_by(&:line)
        end

        def register_semicolon(line, column, after_expression)
          range = source_range(processed_source.buffer, line, column)

          add_offense(range) do |corrector|
            if after_expression
              corrector.replace(range, "\n")
            else
              corrector.remove(range)
            end
          end
        end

        def expressions_per_line(exprs)
          # create a map matching lines to the number of expressions on them
          exprs_lines = exprs.map(&:first_line)
          exprs_lines.group_by(&:itself)
        end

        def find_semicolon_positions(line)
          # Scan for all the semicolons on the line
          semicolons = processed_source[line - 1].enum_for(:scan, ';')
          semicolons.each do
            yield Regexp.last_match.begin(0)
          end
        end
      end
    end
  end
end
