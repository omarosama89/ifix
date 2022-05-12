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
        let(:provider) do
          { provider: {
              mobile_number: mobile_number
            }
          }
        end

        before do
          FactoryBot.create(:provider, mobile_number: mobile_number)
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:provider) do
          {
            provider: {
              mobile_number: '12345xx'
            }
          }
        end

        run_test!
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
        let(:provider) do
          { provider: {
            mobile_number: Faker::PhoneNumber.subscriber_number(length: 11),
            code: code
          }
          }
        end
        
        before do
          allow(CodeAuthenticator).to receive(:check).with(code, nil).and_return(true)
        end

        run_test!
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

        run_test!
      end
    end
  end
end
