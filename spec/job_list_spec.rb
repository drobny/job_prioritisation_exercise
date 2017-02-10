require 'spec_helper'
require 'job_list'

RSpec.describe JobList, type: :model do

  describe '#output_sequence' do
    subject { described_class.new(job_string) }

    context 'when the input is empty' do
      let(:job_string) { '' }

      it 'returns an empty collection' do
        expect(subject.output_sequence).to eq []
      end
    end

    context 'when the input is not empty' do
      let(:job_string)             { 'a => ' }
      let(:job_hash)               { { 'a' => nil } }
      let(:job_sequence_builder)   { instance_double('JobSequenceBuilder', build_sequence: [], job_sequence: ['a']) }

      before do
        allow(subject).to receive(:job_hash).and_return(job_hash)
        allow(JobSequenceBuilder).to receive(:new).with(job_hash).and_return(job_sequence_builder)
      end

      specify 'the sequence builder is run' do
        expect(job_sequence_builder).to receive(:build_sequence)
        subject.output_sequence
      end

      specify 'the job sequence attribute of the builder is returned' do
        allow(job_sequence_builder).to receive(:build_sequence)
        expect(subject.output_sequence).to eq job_sequence_builder.job_sequence
      end
    end

  end
end
