require_relative 'job_sequence_builder'

class JobList
  attr_reader :job_string

  def initialize(job_string)
    @job_string = job_string
  end

  def output_sequence
    return [] if self.job_string.empty?
    calculator = JobSequenceBuilder.new
    calculator.build_sequence(self.job_string)
    calculator.job_sequence
  end

end
