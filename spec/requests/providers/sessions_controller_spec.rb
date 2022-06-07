require 'swagger_helper'

describe 'providers/sessions', type: :request do
  path '/providers/sessions/login' do
    post 'login provider' do
      consumes 'application/json'
      parameter name: :provider, in: :body, schema: {
        type: :object,
        properties: {
          provider: {
            type: :object,
            properties: {
              mobile_number: { type: :string }
            }
          }
        },
        required: %w(mobile_number)
      }

      response '200', 'provider created' do
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let!(:provider_record) { FactoryBot.create(:provider, mobile_number: mobile_number) }
        let(:provider) do
          { provider: {
            mobile_number: mobile_number
          }
          }
        end

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)
        end
      end

      response '422', 'unprocessable entity' do
        let(:provider) do
          {
            provider: {
              mobile_number: '12345xx'
            }
          }
        end

        let(:result) { {"success"=>false, "errors"=>"provider not found"} }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(result)
        end
      end
    end
  end

  path '/providers/sessions/validate' do
    post 'validate provider' do
      consumes 'application/json'
      parameter name: :provider, in: :body, schema: {
        type: :object,
        properties: {
          provider: {
            type: :object,
            properties: {
              mobile_number: { type: :string },
              code: { type: :string },
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
        let(:provider) do
          { provider: {
            mobile_number: Faker::PhoneNumber.subscriber_number(length: 11),
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
