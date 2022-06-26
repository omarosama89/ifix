require 'swagger_helper'

describe 'users/services', type: :request do
  path '/users/services' do
    get 'list services' do
      consumes 'application/json'
      parameter name: 'ifix-uid', in: :header, type: :string, required: true
      parameter name: 'ifix-token', in: :header, type: :string, required: true
      parameter name: 'ifix-mobile-number', in: :header, type: :string, required: true

      response '200', 'services listed' do
        let(:user) { FactoryBot.create(:user) }
        let(:'ifix-uid') { user.id }
        let(:'ifix-mobile-number') { user.mobile_number }
        let(:'ifix-token') { user.token }

        let(:service) { FactoryBot.create(:service) }
        let!(:provider_service) { FactoryBot.create(:provider_service, service: service) }

        let(:result) { [{"id" => service.id, "name" => service.name}] }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to match_array(result)
        end
      end

      response '401', 'unauthorized' do
        let(:'ifix-uid') { 'xx' }
        let(:'ifix-mobile-number') { 'xx' }
        let(:'ifix-token') { 'xx' }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(false)
          expect(parsed_body['message']).to eq('unauthorized')
        end
      end
    end
  end
end
