describe GetRequestPrice do
  describe "#run!" do
    subject { described_class.run!(provider_service_ids: provider_services.map(&:id)) }
    let(:price1) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    let(:price2) { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    let(:provider_service1) { FactoryBot.create(:provider_service, price: price1) }
    let(:provider_service2) { FactoryBot.create(:provider_service, price: price2) }
    let(:provider_services) { [provider_service1, provider_service2] }
    let(:result) { price1 + price2 }

    it 'returns correct price' do
      expect(subject).to eq(result)
    end
  end
end