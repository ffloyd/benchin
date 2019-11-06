require_relative './wrap/report'

module Benchin
  # Benchmark tool for high-level nested measurement. Check out {Report#to_h} for an example of
  # the report structure.
  #
  # It's designed to use when:
  #
  # - you have some slow code (even one execution takes significant time)
  # - you know which blocks of code you have to measure
  # - you have to measure:
  #   - total time spend in each block
  #   - time spend in blocks executed inside a concrete block (child time)
  #   - time spend in a concrete block minus child block's time (self time)
  #
  # By using this information you can discover which block of slow code is the slowest one.
  #
  # Measurement uses WALL time.
  #
  # One of the most common possible examples of usage is to investigate slow requests in legacy and
  # big codebases. In this case more classic instruments like stack profiling can be too
  # focused on particular methods instead of logic chunks in your code.
  #
  # It can be inconvenient to 'drill' {Wrap} instance to all the places where we have to wrap some code.
  # To address this issue we have helper {Benchin.wrap} which uses global {Wrap} instance.
  #
  # @example Measure request timings in controller
  #   class SomeDirtyController < SomeWebFramework::Controller
  #     def create(params)
  #       @bench = Benchin::Wrap.new('CREATE REQUEST')
  #
  #       data = @bench.call('Create Operation') do
  #         do_create(params)
  #       end
  #
  #       @bench.call('Rendering') do
  #         render data
  #       end
  #
  #       File.write('report.txt', @bench.to_s)
  #     end
  #
  #     private
  #
  #     def do_create(params)
  #       do_something(params)
  #       @bench.call('Event Logging') do
  #         log_events
  #       end
  #     end
  #   end
  #   # Report saved to a file will look like:
  #   #
  #   # CREATE REQUEST ->
  #   # |   time(all):       22.0
  #   # |   Create Operation ->
  #   # |   |   calls:              1
  #   # |   |   time(all):       15.0
  #   # |   |   time(self):       5.0
  #   # |   |   time(childs):    10.0
  #   # |   |   Event Logging ->
  #   # |   |   |   calls:              1
  #   # |   |   |   time(all):       10.0
  #   # |   |   |   time(self):      10.0
  #   # |   |   |   time(childs):     0.0
  #   # |   Rendering ->
  #   # |   |   calls:              1
  #   # |   |   time(all):        7.0
  #   # |   |   time(self):       7.0
  #   # |   |   time(childs):     0.0
  class Wrap
    # @return [Report] collected measurement data.
    attr_reader :report

    # @param name [String] report name
    def initialize(name)
      @name = name

      @report = Report.new(@name)
      @current_path = []
    end

    # Resets the {#report} to an empty state.
    #
    # @return [Wrap] self
    def reset
      @report = Report.new(@name)
      @current_path = []

      self
    end

    # Wraps code block with WALL time measurement and returns the block result.
    #
    # Can be used in a nested way.
    #
    # @example Simple measurement
    #   wrap = Benchin::Wrap.new
    #   wrap.call('Sum of strings') do
    #     ['aa', 'bb', 'cc'].sum
    #   end
    #   #=> 'aabbcc'
    #
    # @example Nested measurement
    #   wrap = Benchin::Wrap.new
    #   wrap.call('Big calcultation') do
    #     array = some_expensive_code
    #     processed = array.map do |data|
    #       wrap.call('Nested calcultation') do
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

    # Shortcut for `report.to_s`.
    #
    # @see {Report.to_s}
    # @return [String]
    def to_s
      report.to_s
    end

    # Shortcut for `report.to_h`.
    #
    # @see {Report.to_s}
    # @return [Hash]
    def to_h
      report.to_s
    end
  end
end
