require 'spec_helper'
require 'job_list'

RSpec.describe JobList, type: :model do

  describe '.calculate_sequence_from_input' do

    it 'returns an empty collection if the input passed in is empty' do
      expect(described_class.calculate_sequence_from_input('')).to eq []
    end

    specify 'Given a basic job structure i.e. "a => " return a single job' do
      expect(described_class.calculate_sequence_from_input('a => ')).to eq ['a']
    end

    context 'Given a multiline job structure with no dependent jobs' do
      let(:job_string) do
        <<-EOS
          a =>
          b =>
          c =>
        EOS
      end

      it 'returns the jobs in no particular order' do
        expect(described_class.calculate_sequence_from_input(job_string)).to eq ['a', 'b', 'c']
      end
    end

    context 'Given a multiline job structure with dependent jobs' do
      let(:job_string) do
        <<-EOS
          a =>
          b => c
          c =>
        EOS
      end

      it 'returns the jobs with the independent job before the dependent job' do
        expect(described_class.calculate_sequence_from_input(job_string)).to eq ['c', 'b', 'a']
      end
    end

  end
end
