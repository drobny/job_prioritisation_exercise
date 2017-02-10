require_relative 'job_sequence_error'

class JobStringConverter
  attr_reader :job_string

  def initialize(job_string)
    @job_string = job_string
  end

  def convert_to_hash
    job_string.each_line.inject({}) do |collection, line|
      job, dependent_job = line.gsub(/\s+/, '').split('=>')
      raise JobSequenceError.new('Jobs cannot depend on themselves') if job == dependent_job
      collection.merge job => dependent_job
    end
  end
end
