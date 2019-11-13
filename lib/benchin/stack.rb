require_relative './stack/report'

require 'stackprof'

module Benchin
  DEFAULT_MODE = :cpu
  DEFAULT_INTERVAL = 1_000

  # Stack profiler with focus on modules' usage instead of particular methods.
  #
  # Uses [StackProf](https://github.com/tmm1/stackprof) under the hood.
  #
  # This benchmark is designed to use when:
  #
  # - you have to determine slow modules and libraries in your code
  # - you have to determine the most slowest things in a particular module
  #
  # @example Write report to file
  #   profiler = Benchin::Stack.new
  #
  #   profiler.call do
  #     some_expensive_code
  #   end
  #
  #   File.write('profile.txt', profiler.to_s)
  class Stack
    # @return [Report] stack profile data for all calls
    attr_reader :report

    # @param mode [Symbol] StackProf mode. `:cpu` by default.
    # @param interval [Integer] StackProf interval. 1000 by default (= 1ms).
    def initialize(mode: DEFAULT_MODE, interval: DEFAULT_INTERVAL)
      @mode = mode
      @interval = interval

      @report = Report.new
    end

    # Wraps code block with stack profiling and returns the block result.
    #
    # @yield code block to execute.
    # @return result of provided block execution.
    def call
      result = nil
      profile = StackProf.run(mode: @mode, interval: @interval) do
        result = yield
      end

      @report.add_profile(profile)
      result
    end

    # Shortcut for `report.to_s`.
    #
    # @see Report#to_s
    # @return [String]
    def to_s
      report.to_s
    end

    # Shortcut for `report.to_h`.
    #
    # @see Report#to_h
    # @return [Hash]
    def to_h
      report.to_s
    end
  end
end
