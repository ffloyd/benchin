require_relative './wrap/report'

module Benchin
  # Benchmark tool for high-level nested measurement. Check out {Report#to_h} for an example of
  # the report structure.
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
  #       File.write('report.txt', @bench.report.to_s)
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
  end
end
