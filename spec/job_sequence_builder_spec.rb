require 'spec_helper'
require 'job_sequence_builder'

RSpec.describe JobSequenceBuilder, type: :model do

  describe '#build_sequence' do
    context 'when the job hash is valid' do
      subject { described_class.new(job_hash) }

      before { subject.build_sequence }

      context 'Given a basic job structure with one line' do
        let(:job_hash) { { 'a' => nil } }

        it 'returns a single job' do
          expect(subject.job_sequence).to eq ['a']
        end
      end

      context 'Given job structure with no dependent jobs' do
        let(:job_hash) do
          {
            'a' => nil,
            'b' => nil,
            'c' => nil,
          }
        end

        it 'returns the jobs in no particular order' do
          expect(subject.job_sequence).to eq ['a', 'b', 'c']
        end
      end

      context 'Given a job structure with one dependent job' do
        let(:job_hash) do
          {
            'a' => nil,
            'b' => 'c',
            'c' => nil
          }
        end

        it 'returns the jobs with the independent job before the dependent job' do
          expect(subject.job_sequence).to eq ['a', 'c', 'b']
        end
      end

      context 'Given a job structure with multiple dependent jobs' do
        let(:job_hash) do
          {
            'a' => nil,
            'b' => 'c',
            'c' => 'f',
            'd' => 'a',
            'e' => 'b',
            'f' => nil
          }
        end

        it 'returns the jobs with the independent job before the dependent job' do
          expect(subject.job_sequence).to eq ['a', 'd', 'f', 'c', 'b', 'e']
        end
      end

      context 'Given another multiline job structure with dependent jobs' do
        let(:job_hash) do
          {
            'a' => 'e',
            'b' => 'd',
            'c' => nil,
            'd' => 'a',
            'e' => 'f',
            'f' => nil
          }
        end

        it 'returns the jobs with the independent job before the dependent job' do
          expect(subject.job_sequence).to eq ['f', 'e', 'a', 'd', 'b', 'c']
        end

      end
    end

    context 'when there are jobs that are have circular dependencies' do
      let(:job_hash) do
        {
          'a' => nil,
          'b' => 'c',
          'c' => 'f',
          'd' => 'a',
          'e' => nil,
          'f' => 'b'
        }
      end

      it 'returns an error stating jobs cannot have circular dependencies' do
        expect{ described_class.new(job_hash).build_sequence }.to raise_error(JobSequenceError, 'Jobs cannot have circular dependencies')
      end
    end

  end
end
