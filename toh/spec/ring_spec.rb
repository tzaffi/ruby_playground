require_relative '../app/ring'

describe Ring do
  let(:instance) { described_class.new(width, num_rings) }

  let(:width) { 4 }
  let(:num_rings) { 7 }

  describe '#to_s' do
    subject { "#{instance}" }

    it { is_expected.to eq '   <<<<||>>>>   ' }
  end

  describe '#margin' do
    subject { instance.send(:margin) }

    context 'when num_rings is bigger than width' do
      it { is_expected.to eq '   ' }
    end

    context 'when num_rings == width' do
      let(:num_rings) { width }

      it { is_expected.to eq '' }
    end

    context 'when num_rings is smaller than width' do
      let(:num_rings) { width - 1 }

      it do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

end