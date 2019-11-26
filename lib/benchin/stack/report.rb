require_relative './report/tree'

module Benchin
  class Stack
    # Represents StackProf frame data in a more module-focused format.
    #
    # @api private
    class Report
      def initialize
        @missed_samples = 0
        @tree = Tree.new
      end

      def add_profile(stackprof_data)
        @tree.add_to_root(missed_samples: stackprof_data[:missed_samples])
        process_frames(stackprof_data[:frames])

        self
      end

      def to_s
        @tree.postprocess.to_s
      end

      def to_h
        @tree.postprocess.to_h
      end

      private

      def process_frames(frames)
        frames.values.each do |name:, samples:, **|
          next if samples.zero?

          name_path = name.split(/\:\:|(\.\w+\??\!?)|(\#\w+\??\!?)/)

          @tree.add(name_path, samples: samples)
        end
      end
    end
  end
end
