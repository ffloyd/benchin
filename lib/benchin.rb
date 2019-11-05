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
  end
end
