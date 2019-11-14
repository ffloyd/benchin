require_relative './report_node'

module Benchin
  class Stack
    # Represents StackProf frame data in a more module-focused format.
    #
    # @api private
    class Report
      def initialize
        @missed_samples = 0
        @root_node = ReportNode.new('ROOT')
      end

      def add_profile(stackprof_data)
        @missed_samples += stackprof_data[:missed_samples]

        process_frames(stackprof_data[:frames])

        self
      end

      def to_s
        to_h.inspect
      end

      def to_h
        @root_node.to_h.merge(missed_samples: @missed_samples)
      end

      private

      def process_frames(frames)
        frames.values.each do |name:, samples:, **|
          path = name.split(/\:\:|(\#\w+)/)

          @root_node.add_samples(samples, path)
        end
      end
    end
  end
end
