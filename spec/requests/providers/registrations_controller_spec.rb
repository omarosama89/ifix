require 'swagger_helper'

describe 'providers/registrations', type: :request do
  path '/providers/registrations/sign_up' do
    post 'Sign up provider' do
      consumes 'application/json'
      parameter name: :provider, in: :body, schema: {
        type: :object,
        properties: {
          provider: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              mobile_number: { type: :string },
              lat: { type: :string },
              lng: { type: :string },
              provider_services_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    service_id: { type: :integer },
                    price: { type: :number }
                  }
                }
              }
            }
          }
        },
        required: %w(first_name last_name mobile_number lat lng provider_services_attributes)
      }

      response '201', 'provider created' do
        let!(:service) { FactoryBot.create(:service) }
        let(:provider) do
          { provider: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            mobile_number: Faker::PhoneNumber.subscriber_number(length: 11),
            lat: '30.056837',
            lng: '31.238075',
            provider_services_attributes: [{service_id: service.id, price: 50}]
          }
          }
        end

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)
          expect(Provider.count).to be(1)
          expect(Provider.last.provider_services.count).to eq(1)
          expect(Provider.last.provider_services.last.service_id).to eq(service.id)
        end
      end

      response '422', 'unprocessable entity' do
        let(:provider) do
          {
            provider: {
              first_name: Faker::Name.first_name
            }
          }
        end
        let(:result) do
          {"last_name"=>["can't be blank"], "mobile_number"=>["can't be blank"]}
        end

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(false)
          expect(parsed_body['errors']).to eq(result)
        end
      end
    end
  end

  path '/providers/registrations/validate' do
    post 'validate provider' do
      consumes 'application/json'
      parameter name: :provider, in: :body, schema: {
        type: :object,
        properties: {
          provider: {
            type: :object,
            properties: {
              mobile_number: { type: :string },
              code: { type: :string }
            }
          }
        },
        required: %w(mobile_number code)
      }

      response '200', 'provider validated' do
        let(:code) { '1234' }
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let!(:provider_record) { FactoryBot.create(:provider, mobile_number: mobile_number) }
        let(:provider) do
          { provider: {
            mobile_number: mobile_number,
            code: code
          }
          }
        end

        before do
          allow(CodeAuthenticator).to receive(:check).with(code, nil).and_return(true)
        end

        run_test! do
          provider_record.reload

          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)

          headers = response.headers
          expect(headers['ifix-uid']).to eq(provider_record.id)
          expect(headers['ifix-mobile-number']).to eq(provider_record.mobile_number)
          expect(headers['ifix-token']).to eq(provider_record.token)
          expect(headers['ifix-reset-token']).to eq(provider_record.reset_token)
        end
      end

      response '422', 'provider invalidated' do
        let(:code) { '1234' }
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let!(:provider_record) { FactoryBot.create(:provider, mobile_number: mobile_number) }
        let(:provider) do
          { provider: {
            mobile_number: mobile_number,
            code: code
          }
          }
        end

        before do
          allow(CodeAuthenticator).to receive(:check).with(code, nil).and_return(false)
        end

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(false)

          headers = response.headers
          expect(headers['ifix-uid']).to eq(nil)
          expect(headers['ifix-mobile-number']).to eq(nil)
          expect(headers['ifix-token']).to eq(nil)
          expect(headers['ifix-reset-token']).to eq(nil)
        end
      end
    end
  end
end
