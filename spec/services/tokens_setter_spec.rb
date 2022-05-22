describe TokensSetter do
  include Dry::Monads[:result]
  
  describe "#run!" do
    subject { described_class.run!(object: object) }

    shared_examples_for 'success_scenario' do
      it 'successfuly updates user' do
        expect(subject.success?).to be(true)
      end

      it 'sets token' do
        subject
        expect(object.token).not_to be(nil)
      end

      it 'persists object' do
        subject
        expect(object).to be_persisted
      end
    end

    shared_examples_for 'failure_scenario' do
      it 'failed to update user' do
        expect(subject.success?).to be(false)
      end

      it "doesn't persist user" do
        subject
        expect(object).not_to be_persisted
      end
    end

    context "user" do
      context "success" do
        let(:object) { FactoryBot.build(:user) }

        include_examples 'success_scenario'
      end

      context 'failure' do
        let(:object) { FactoryBot.build(:user, first_name: nil) }

        include_examples 'failure_scenario'
      end
    end

    context "provider" do
      context "success" do
        let(:object) { FactoryBot.build(:provider) }

        include_examples 'success_scenario'
      end

      context 'failure' do
        let(:object) { FactoryBot.build(:provider, first_name: nil) }

        include_examples 'failure_scenario'
      end
    end
  end
end