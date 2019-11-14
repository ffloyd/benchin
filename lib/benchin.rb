require 'benchin/version'

require 'benchin/wrap'
require 'benchin/stack'

# Benchmarking toolset.
#
# @example Using {Wrap} global instance
#   Benchin.wrap.reset
#   Benchin.wrap.call('Expesive Code') do
#     expesive_logic
#     10.times do
#       Benchin.wrap.call('Nested Hot Operation') { do_something }
#     end
#   end
#
#   puts Benchin.wrap
#
# @example Using {Stack} shortcut instance
#   report = Benchin.stack do
#     expesive_logic
#   end
#
#   puts report.to_s
#
# @see Wrap
# @see Stack
module Benchin
  # Base error class
  class Error < StandardError; end

  class << self
    # Returns global instance of {Wrap}.
    #
    # It can be used to simplify usage when you have
    # to wrap code in many different places in your project.
    #
    # @see Wrap
    # @return [Wrap]
    def wrap
      @wrap ||= Wrap.new('GLOBAL')
    end

    # Shortcut for stack profiling
    #
    # @yield code block to profile
    # @return [::Benchin::Stack::Report] generated report
    def stack(&block)
      stack_profiler = ::Benchin::Stack.new

      stack_profiler.call(&block)

      stack_profiler.report
    end
  end
end
