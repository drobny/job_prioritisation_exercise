class JobList
  attr_reader   :job_string
  attr_accessor :job_sequence

  def initialize(job_string)
    @job_string = job_string
    @job_sequence = []
  end

  def calculate_sequence
    return [] if self.job_string.empty?
    self.job_string.each_line do |line|
      job, dependent_job = line.gsub(/\s+/, '').split('=>')
      if dependent_job
        self.job_sequence = [dependent_job, job] + self.job_sequence
      elsif !self.job_sequence.include?(job)
        self.job_sequence << job
      end
    end
    self.job_sequence
  end

end
