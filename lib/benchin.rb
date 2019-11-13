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
# @see Wrap
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
  end
end
