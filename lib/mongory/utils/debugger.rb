# frozen_string_literal: true

module Mongory
  module Utils
    # Debugger is a singleton utility for tracing matcher execution in a tree-like format.
    #
    # It captures each matcher evaluation with indentation and visualizes the hierarchy,
    # helping developers understand nested matcher flows (e.g. `$and`, `$or`, etc).
    #
    # Usage:
    #   Debugger.with_indent { ... } # wraps around matcher logic
    #   Debugger.display        # prints trace tree after execution
    #
    # Note:
    # The trace is recorded in post-order (leaf nodes enter first),
    # and `reorder_traces_for_display` is used to transform it into a
    # pre-order format suitable for display.
    TraceEntry = Struct.new(:text, :level) do
      def formatted
        "#{'  ' * level}#{text}"
      end
    end

    Debugger = SingletonBuilder.new('Mongory::Debugger') do
      @indent_level = -1
      @trace_entries = []

      # Enables debug mode by aliasing `match?` to `debug_match`.
      def enable
        Matchers::AbstractMatcher.alias_method :match?, :debug_match
      end

      # Disables debug mode by restoring `match?` to `regular_match`.
      def disable
        Matchers::AbstractMatcher.alias_method :match?, :regular_match
      end

      # Wraps a matcher evaluation block with indentation control.
      #
      # It increments the internal indent level before the block,
      # and decrements it after. The yielded block's return value
      # is used as trace content and pushed onto the trace_entries.
      #
      # @yieldreturn [String] the trace content to log
      # @return [Object] the result of the block
      def with_indent
        @indent_level += 1
        display_string = yield
        @trace_entries << TraceEntry.new(display_string, @indent_level)
      ensure
        @indent_level -= 1
      end

      # Prints the visualized trace tree to STDOUT.
      #
      # This processes the internal trace_entries (post-order) into
      # a structured pre-order list that represents nested matcher evaluation.
      # @return [void]
      def display
        reorder_traces_for_display(@trace_entries).each do |trace|
          puts trace.formatted
        end

        @trace_entries.clear
        nil
      end

      # Recursively reorders trace lines by indentation level to produce a
      # display-friendly structure where parents precede children.
      #
      # The original trace is built in post-order (leaf first), and this method
      # transforms it into a pre-order structure suitable for tree display.
      #
      # @param traces [Array<TraceEntry>] the raw trace lines (leaf-first)
      # @param level [Integer] current processing level
      # @return [Array<TraceEntry>] reordered trace lines for display
      def reorder_traces_for_display(traces, level = 0)
        result = []
        group = []
        traces.each do |trace|
          if trace.level == level
            result << trace
            result.concat reorder_traces_for_display(group, level + 1)
            group = []
          else
            group << trace
          end
        end

        result
      end

      def clear
        @trace_entries.clear
      end
    end
  end
end
