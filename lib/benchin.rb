require 'benchin/version'
require 'benchin/wrap'

# Benchmarking toolset.
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
