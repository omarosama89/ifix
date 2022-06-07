describe FilterProviderServicesByDistance do
  let(:point) { Point.new(lat: 30.056837, lng: 31.238075) }
  let(:provider1) { FactoryBot.create(:provider, lat: 30.156837, lng: 31.238075) }
  let(:provider2) { FactoryBot.create(:provider, lat: 30.556837, lng: 31.238075) }
  let(:provider_service1) { FactoryBot.create(:provider_service, provider: provider1) }
  let(:provider_service2) { FactoryBot.create(:provider_service, provider: provider2) }
  let(:provider_services) { [provider_service1, provider_service2] }
  let(:max_distance) { 40 }

  describe "#run!" do
    subject { described_class.run!(point: point, provider_services: provider_services, max_distance: max_distance) }

    it 'returns provider_services within max_distance' do
      expect(subject).to eq([provider_service1])
    end
  end
end