require 'spec_helper'
require 'job_list'

RSpec.describe JobList, type: :model do

  describe '.calculate_sequence' do

    it 'returns an empty collection if the input passed in is empty' do
      expect(described_class.calculate_sequence_from_input('')).to eq []
    end

  end
end
