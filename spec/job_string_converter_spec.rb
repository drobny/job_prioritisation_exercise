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
  end
end
