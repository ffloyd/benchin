require 'benchin/version'
require 'benchin/wrap'

# Benchmarking toolset. This module contains aliases to public methods of {Wrap}, ...
module Benchin
  # Base error class
  class Error < StandardError; end

  class << self
    # Alias for {Wrap.reset}.
    #
    # {include:Wrap.reset}
    def wrap_reset
      Wrap.reset
    end

    # Alias for {Wrap.call}.
    #
    # {include:Wrap.call}
    def wrap(name, &block)
      Wrap.call(name, &block)
    end

    # Alias for {Wrap.report}.
    #
    # {include:Wrap.report}
    #
    # @return [Wrap::Report] current report, use {Wrap::Report#to_s} for printing.
    def wrap_report
      Wrap.report
    end
  end
end
