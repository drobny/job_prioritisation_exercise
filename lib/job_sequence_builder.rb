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
      generate_sequence_for_job(job)
    end
  end

  private
    def generate_sequence_for_job(job)
      parent_job = self.job_hash.key(job)      
      raise JobSequenceError.new('Jobs cannot have circular dependencies') if self.job_sequence.index(parent_job) && self.job_sequence.index(job) && self.job_sequence.index(parent_job) < self.job_sequence.index(job)
      if self.job_sequence.include?(parent_job) && !self.job_sequence.include?(job) && !job.nil?
        self.job_sequence.insert(self.job_sequence.index(parent_job), job)
      elsif !self.job_sequence.include?(job)
        self.job_sequence << job
      end

      generate_sequence_for_job(parent_job) if parent_job
    end

end
