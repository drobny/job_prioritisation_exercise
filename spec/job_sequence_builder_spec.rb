require 'spec_helper'
require 'job_sequence_builder'
require 'job_sequence_error'

RSpec.describe JobSequenceBuilder, type: :model do

  describe '#build_sequence' do
    context 'when the job string is valid' do
      before  { subject.build_sequence(job_string) }

      context 'Given a basic job structure with one line' do
        let(:job_string) { 'a => ' }

        it 'returns a single job' do
          expect(subject.job_sequence).to eq ['a']
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
          expect(subject.job_sequence).to eq ['a', 'b', 'c']
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
          expect(subject.job_sequence).to eq ['c', 'b', 'a']
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
          expect(subject.job_sequence).to eq ['f', 'c', 'b', 'e', 'a', 'd']
        end
      end
    end

    context 'when there are jobs that are dependent on themselves' do
      let(:job_string) do
        <<-EOS
          a =>
          b =>
          c => c
        EOS
      end

      it 'returns an error stating jobs cannot depend on themselves' do
        expect{ subject.build_sequence(job_string) }.to raise_error(JobSequenceError, 'Jobs cannot depend on themselves')
      end
    end

    context 'when there are jobs that are have circular dependencies' do
      let(:job_string) do
        <<-EOS
          a =>
          b => c
          c => f
          d => a
          e =>
          f => b
        EOS
      end

      it 'returns an error stating jobs cannot have circular dependencies' do
        expect{ subject.build_sequence(job_string) }.to raise_error(JobSequenceError, 'Jobs cannot have circular dependencies')
      end
    end

  end
end
