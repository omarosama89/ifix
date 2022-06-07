require 'swagger_helper'

describe 'users/provider_services', type: :request do
  path '/users/provider_services' do
    get 'list provider services' do
      consumes 'application/json'
      parameter name: 'ifix-uid', in: :header, type: :string, required: true
      parameter name: 'ifix-token', in: :header, type: :string, required: true
      parameter name: 'ifix-mobile-number', in: :header, type: :string, required: true

      parameter name: :service_ids, in: :query, type: :string, description: 'service ids comma separated', required: true
      parameter name: :lat, in: :query, type: :string, required: true
      parameter name: :lng, in: :query, type: :string, required: true
      parameter name: :max_distance, in: :query, type: :integer, required: false

      response '200', 'provider services listed (missing max_distance)' do
        let(:user) { FactoryBot.create(:user) }
        let(:'ifix-uid') { user.id }
        let(:'ifix-mobile-number') { user.mobile_number }
        let(:'ifix-token') { user.token }

        let(:service1) { FactoryBot.create(:service) }
        let(:service2) { FactoryBot.create(:service) }
        let(:service_ids) { "#{service1.id},#{service2.id}" }
        let(:provider1) { FactoryBot.create(:provider, lat: 30.156837, lng: 31.238075) }
        let(:provider2) { FactoryBot.create(:provider, lat: 30.556837, lng: 31.238075) }
        let!(:provider_service1) { FactoryBot.create(:provider_service, provider: provider1, service: service1) }
        let!(:provider_service2) { FactoryBot.create(:provider_service, provider: provider2, service: service2) }
        let(:lat) { '30.056837' }
        let(:lng) { '31.238075' }

        let(:result) do
          [{
             "id" => provider_service1.id, "name" => provider_service1.name, "price" => provider_service1.price, "provider_id" => provider_service1.provider_id
           }]
        end

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body.length).to eq(1)
          expect(parsed_body).to match_array(result)
        end
      end

      response '200', 'provider services listed' do
        let(:user) { FactoryBot.create(:user) }
        let(:'ifix-uid') { user.id }
        let(:'ifix-mobile-number') { user.mobile_number }
        let(:'ifix-token') { user.token }

        let(:service1) { FactoryBot.create(:service) }
        let(:service2) { FactoryBot.create(:service) }
        let(:service_ids) { "#{service1.id},#{service2.id}" }
        let(:provider1) { FactoryBot.create(:provider, lat: 30.156837, lng: 31.238075) }
        let(:provider2) { FactoryBot.create(:provider, lat: 30.556837, lng: 31.238075) }
        let!(:provider_service1) { FactoryBot.create(:provider_service, provider: provider1, service: service1) }
        let!(:provider_service2) { FactoryBot.create(:provider_service, provider: provider2, service: service2) }
        let(:lat) { '30.056837' }
        let(:lng) { '31.238075' }
        let(:max_distance) { 100 }
        let(:result) do
          [{
             "id" => provider_service1.id, "name" => provider_service1.name, "price" => provider_service1.price, "provider_id" => provider_service1.provider_id
           },
           {
             "id" => provider_service2.id, "name" => provider_service2.name, "price" => provider_service2.price, "provider_id" => provider_service2.provider_id
           }]
        end

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body.length).to eq(2)
          expect(parsed_body).to match_array(result)
        end
      end

      response '401', 'unauthorized' do
        let(:'ifix-uid') { 'xx' }
        let(:'ifix-mobile-number') { 'xx' }
        let(:'ifix-token') { 'xx' }

        let(:service1) { FactoryBot.create(:service) }
        let(:service2) { FactoryBot.create(:service) }
        let(:services) { [service1, service2] }
        let(:service_ids) { services.map(&:id) }
        let(:provider1) { FactoryBot.create(:provider, lat: 30.156837, lng: 31.238075) }
        let(:provider2) { FactoryBot.create(:provider, lat: 30.556837, lng: 31.238075) }
        let!(:provider_service1) { FactoryBot.create(:provider_service, provider: provider1) }
        let!(:provider_service2) { FactoryBot.create(:provider_service, provider: provider2) }
        let(:lat) { '30.056837' }
        let(:lng) { '31.238075' }
        let(:max_distance) { 40 }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(false)
          expect(parsed_body['message']).to eq('unuthorized')
        end
      end
    end
  end
end
