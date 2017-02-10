require_relative 'job_string_converter'
require_relative 'job_sequence_builder'

class JobList
  attr_reader :job_string

  def initialize(job_string)
    @job_string = job_string
  end

  def output_sequence
    return [] if self.job_string.empty?
    sequence_builder = JobSequenceBuilder.new(job_hash)
    sequence_builder.build_sequence
    sequence_builder.job_sequence
  end

  private
    def job_hash(klass = JobStringConverter)
      klass.new(job_string).convert_to_hash
    end

end
