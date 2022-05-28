describe GetDistance do
  describe "#run!" do
    subject { described_class.run!(a: cairo, b: alex) }

    let(:cairo) do
      Point.new(
        lat: 30.056837,
        lng: 31.238075
      )
    end
    let(:alex) do
      Point.new(
        lat: 31.216765,
        lng: 29.910906
      )
    end
    let(:distance) { 181 }

    it 'returns distance in Kilometers' do
      expect(subject).to eq(distance)
    end
  end
end