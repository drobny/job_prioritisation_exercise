class JobList

  def self.calculate_sequence_from_input(input)
    if input.empty?
      []
    else
      input.each_line.inject([]) do |collection, line|
        job, dependent_job = line.gsub(/\s+/, '').split('=>')
        if dependent_job
          [dependent_job, job] + collection
        else
          collection << job unless collection.include?(job)
          collection
        end
      end
    end
  end

end
