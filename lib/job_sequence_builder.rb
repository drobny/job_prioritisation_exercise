require_relative 'job_sequence_error'

class JobSequenceBuilder
  attr_reader   :job_hash
  attr_reader   :job_sequence

  def initialize(job_hash)
    @job_hash = job_hash
    @job_sequence = []
  end

  def build_sequence
    self.job_hash.keys.each do |job|
      add_job_to_sequence(job)
    end
  end

  private

    # Traverse each job up the tree, recursively calling this method for each
    # parent job
    def add_job_to_sequence(job)
      parent_job = self.job_hash.key(job)
      raise JobSequenceError.new('Jobs cannot have circular dependencies') if circular_dependency?(parent_job, job)

      if job_already_processed?(parent_job) && !job_already_processed?(job) && job
        self.job_sequence.insert(self.job_sequence.index(parent_job), job)
      elsif !job_already_processed?(job)
        self.job_sequence << job
      end

      add_job_to_sequence(parent_job) if parent_job
    end

    def job_already_processed?(job)
      self.job_sequence.include?(job)
    end

    # If the parent job and the dependent job are already in the sequence
    # then is a circular dependency if dependent job appears before the parent
    def circular_dependency?(parent_job, dependent_job)
      parent_job_index = self.job_sequence.index(parent_job)
      dependent_job_index = self.job_sequence.index(dependent_job)
      parent_job_index && dependent_job_index && parent_job_index < dependent_job_index
    end

end
