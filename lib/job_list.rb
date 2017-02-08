class JobList

  def self.calculate_sequence_from_input(input)
    if input.empty?
      []
    else
      input.gsub(/\s+/, '').split('=>')
    end
  end

end
