require 'job_string_converter'

RSpec.describe JobStringConverter, type: :model do

  describe '#convert_to_hash' do
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

    subject { described_class.new(job_string) }

    specify 'it returns a hash of jobs being the key and dependent jobs being the value' do
      expect(subject.convert_to_hash).to eq({
        'a' => nil,
        'b' => 'c',
        'c' => 'f',
        'd' => 'a',
        'e' => 'b',
        'f' => nil
      })
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
        expect{ subject.convert_to_hash }.to raise_error(JobSequenceError, 'Jobs cannot depend on themselves')
      end
    end
  end
end
