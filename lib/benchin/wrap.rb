require_relative './wrap/report'

module Benchin
  # Benchmark tool for high-level nested measurement. Check out {Report#to_a} for an example of
  # the report structure.
  #
  # General approach is to {.reset} first, then execute code with injected measurements ({.call}), then use {.report} to
  # access data and represent it in a desired way.
  module Wrap
    class << self
      # @return [Report] collected measurement data.
      attr_reader :report

      # Reset the {.report} to an empty state.
      def reset
        @report = Report.new
        @current_path = []
        nil
      end

      # Wraps code block with time measurement and returns the block result.
      #
      # Can be used in a nested way.
      #
      # @example Simple measurement
      #   Benchin::Wrap.call('Sum of stings') do
      #     ['aa', 'bb', 'cc'].sum
      #   end
      #   #=> 'aabbcc'
      #
      # @example Nested measurement
      #   Benchin::Wrap.call('Big calcultation') do
      #     array = some_expensive_code
      #     processed = array.map do |data|
      #       Benchin::Wrap.call('Nested calcultation') do
      #         some_tranformation(data)
      #       end
      #     end
      #     send_somewhere(processed)
      #   end
      #
      # @param name [String] name for code block in reporting.
      # @yield code block to execute.
      # @return result of provided block execution.
      def call(name)
        @current_path.push name
        starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        result = yield
        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = ending - starting

        report.add_time(@current_path, elapsed)
        @current_path.pop

        result
      end
    end
  end
end
