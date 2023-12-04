# frozen_string_literal: true

require_relative '../../days/base'

describe Days::Base do
  let(:lines) { [] }

  subject { described_class.new(lines) }

  it 'requires part1 to be implemented' do
    expect { subject.part1 }.to raise_error(NotImplementedError)
  end

  it 'requires part2 to be implemented' do
    expect { subject.part1 }.to raise_error(NotImplementedError)
  end

  describe '.solve' do
    subject { described_class.solve(part, lines) }

    context 'when part is 1' do
      let(:part) { 1 }

      it 'solves part 1' do
        expect_any_instance_of(described_class)
          .to receive(:part1).and_return(0)

        expect(subject).to eq(0)
      end
    end

    context 'when part is 2' do
      let(:part) { 2 }

      it 'calls part2' do
        expect_any_instance_of(described_class)
          .to receive(:part2).and_return(0)

        expect(subject).to eq(0)
      end
    end
  end
end
