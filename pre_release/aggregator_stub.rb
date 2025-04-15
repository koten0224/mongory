module Mongory
  class Aggregator
    attr_reader :records, :pipeline

    def initialize(records, pipeline = [])
      @records = records
      @pipeline = normalize_pipeline(pipeline)
    end

    def self.aggregate(records, pipeline = nil)
      if block_given?
        raise ArgumentError, "Block-style DSL not implemented yet"
      end

      new(records, pipeline).execute
    end

    def execute
      result = records
      pipeline.each do |stage|
        stage_name, stage_spec = stage.first
        stage_class = lookup_stage(stage_name)
        result = stage_class.new(result, stage_spec).call
      end
      result
    end

    def explain
      {
        pipeline: pipeline.map do |stage|
          stage_name, stage_spec = stage.first
          stage_class = lookup_stage(stage_name)
          stage_class.new([], stage_spec).explain
        end
      }
    end

    private

    def normalize_pipeline(raw_pipeline)
      raw_pipeline.map do |stage|
        raise TypeError, "Stage must be a Hash" unless stage.is_a?(Hash)
        raise ArgumentError, "Stage must have exactly one key" unless stage.size == 1
        stage
      end
    end

    def lookup_stage(name)
      const = name.to_s.sub(/^\$/, '').capitalize + "Stage"
      Mongory::Aggregate::Stages.const_get(const)
    rescue NameError
      raise ArgumentError, "Unknown aggregate stage: #{name}"
    end
  end
end
