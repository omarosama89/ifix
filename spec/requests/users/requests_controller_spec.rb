require 'swagger_helper'

describe 'users/requests', type: :request do
  path '/users/requests' do
    post 'create request' do
      consumes 'application/json'
      parameter name: 'ifix-uid', in: :header, type: :string, required: true
      parameter name: 'ifix-token', in: :header, type: :string, required: true
      parameter name: 'ifix-mobile-number', in: :header, type: :string, required: true

      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          request: {
            type: :object,
            properties: {
              lat: { type: :string },
              lng: { type: :string },
              request_details_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    request_id: { type: :integer },
                    provider_service_id: { type: :integer }
                  }
                }
              }
            }
          }
        }
      }

      response '201', 'request created' do
        let(:user) { FactoryBot.create(:user) }
        let(:'ifix-uid') { user.id }
        let(:'ifix-mobile-number') { user.mobile_number }
        let(:'ifix-token') { user.token }

        let(:service1) { FactoryBot.create(:service) }
        let(:service2) { FactoryBot.create(:service) }
        let!(:provider_service1) { FactoryBot.create(:provider_service, service: service1) }
        let!(:provider_service2) { FactoryBot.create(:provider_service, service: service2) }
        let(:request) do
          {
            lat: Faker::Address.latitude.to_s,
            lng: Faker::Address.longitude.to_s,
            request_details_attributes: [
              {
                provider_service_id: provider_service1.id
              },
              {
                provider_service_id: provider_service2.id
              }
            ]
          }
        end

        let(:result) { { "success" => true } }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to match_array(result)
          expect(Request.last.status).to eq(Request::STATUSES[:pending])
        end
      end

      response '401', 'unauthorized' do
        let(:'ifix-uid') { 'xx' }
        let(:'ifix-mobile-number') { 'xx' }
        let(:'ifix-token') { 'xx' }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(false)
          expect(parsed_body['errors']).to eq('unauthorized')
        end
      end
    end
  end
end
