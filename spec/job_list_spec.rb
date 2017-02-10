require 'spec_helper'
require 'job_list'

RSpec.describe JobList, type: :model do

  describe '#calculate_sequence' do
    subject { described_class.new(job_string) }
    let(:calculated_sequence) { subject.calculate_sequence }

    context 'when the input is empty' do
      let(:job_string) { '' }

      it 'returns an empty collection' do
        expect(calculated_sequence).to eq []
      end
    end

    context 'Given a basic job structure with one line' do
      let(:job_string) { 'a => ' }

      it 'returns a single job' do
        expect(calculated_sequence).to eq ['a']
      end
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
        expect(calculated_sequence).to eq ['a', 'b', 'c']
      end
    end

    context 'Given a multiline job structure with one dependent job' do
      let(:job_string) do
        <<-EOS
          a =>
          b => c
          c =>
        EOS
      end

      it 'returns the jobs with the independent job before the dependent job' do
        expect(calculated_sequence).to eq ['c', 'b', 'a']
      end
    end

    context 'Given a multiline job structure with multiple dependent jobs' do
      let(:job_string) do
        <<-EOS
          a =>
          b => c
          c => f
          d => a
          e => b
          f =>
        EOS
      end

      it 'returns the jobs with the independent job before the dependent job' do
        expect(calculated_sequence).to eq ['f', 'c', 'b', 'e', 'a', 'd']
      end
    end

  end
end
