class JobSequenceBuilder
  attr_accessor :job_sequence

  def initialize
    @job_sequence = []
  end

  def build_sequence(job_string)
    job_string.each_line do |line|
      job, dependent_job = line.gsub(/\s+/, '').split('=>')
      raise JobSequenceError.new("Jobs cannot depend on themselves") if job == dependent_job
      if dependent_job.nil?
        self.job_sequence << job if job_not_in_current_sequence?(job)
      else
        add_to_sequence(job, dependent_job)
      end
    end
  end

  private
    def add_to_sequence(job, dependent_job)
      job_index           = self.job_sequence.index(job)
      dependent_job_index = self.job_sequence.index(dependent_job)

      if job_index && dependent_job_index && job_index < dependent_job_index
        raise JobSequenceError.new("Jobs cannot have circular dependencies")
      end

      if job_index && job_not_in_current_sequence?(dependent_job)
        self.job_sequence.insert(job_index, dependent_job)
      elsif dependent_job_index && job_not_in_current_sequence?(job)
        self.job_sequence.insert(dependent_job_index + 1, job)
      elsif job_not_in_current_sequence?(job) && job_not_in_current_sequence?(dependent_job)
        self.job_sequence = [dependent_job, job] + self.job_sequence
      end
    end

    def job_not_in_current_sequence?(job)
      !self.job_sequence.include?(job)
    end

end
