module Benchin
  class Stack
    # Represents StackProf frame data in a more module-focused format.
    #
    # @api private
    class Report
      def initialize
        @profiles = []
      end

      def add_profile(profile)
        @profiles << profile
        self
      end

      def to_s
        @profiles.map(&:inspect).join("\n")
      end

      def to_h
        @profiles.map(&:to_h)
      end
    end
  end
end
