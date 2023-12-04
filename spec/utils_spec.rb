# frozen_string_literal: true

require_relative '../utils'

describe Utils do
  describe '.load' do
    let(:test) { false }
    let(:day) { 5 }
    let(:lines) { ['line 1', 'line 2', 'line 3'] }

    subject { described_class.load(day, test: test) }

    before do
      allow(File).to receive(:readlines)
        .and_return(lines)
    end

    context 'when test is false' do
      it 'loads the file' do
        expect(File).to receive(:readlines)
          .with("input/d#{day}.txt").and_return(lines)

        expect(subject).to eq(lines)
      end
    end

    context 'when test is true' do
      let(:test) { true }

      it 'loads the file' do
        expect(File).to receive(:readlines)
          .with("input/d#{day}_test.txt").and_return(lines)

        expect(subject).to eq(lines)
      end
    end

    context 'when lines start with #' do
      let(:lines) { super() + ['# comment 1', '#comment 2'] }

      it 'ignores the commented out lines' do
        expect(subject).to eq(lines[0...-2])
      end
    end

    context 'when lines end with or contain #' do
      let(:lines) { ['line 1 #', 'line#2'] }

      it 'does not mutate them' do
        expect(subject).to eq(lines)
      end
    end

    context 'when lines have surrounding whitespace' do
      let(:lines) { super().map { |line| "  #{line}  " } }

      it 'removes the whitespace' do
        expect(subject).to eq(lines.map(&:strip))
      end
    end
  end
end
