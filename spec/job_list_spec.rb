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
      let(:job_sequence_builder)   { instance_double('JobSequenceBuilder', build_sequence: [], job_sequence: ['a']) }

      context 'and the string has not been converted to a hash' do

        before { allow(JobSequenceBuilder).to receive(:new).and_return(job_sequence_builder) }

        specify 'the string input is converted to a hash' do          
          converter_instance = instance_double('JobStringConverter')
          allow(JobStringConverter).to receive(:new).with(job_string).and_return(converter_instance)
          expect(converter_instance).to receive(:convert_to_hash)
          subject.output_sequence
        end

      end

      context 'and the string has been converted to a hash' do
        let(:job_hash) { { 'a' => nil } }

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
end
