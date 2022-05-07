require 'swagger_helper'

describe 'users/sessions', type: :request do
  path '/users/sessions/login' do
    post 'login user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          mobile_number: { type: :string }
        },
        required: %w(mobile_number)
      }

      response '200', 'user created' do
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let(:user) do
          { user: {
              mobile_number: mobile_number
            }
          }
        end

        before do
          FactoryBot.create(:user, mobile_number: mobile_number)
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:user) do
          {
            user: {
              mobile_number: '12345xx'
            }
          }
        end

        run_test!
      end
    end
  end
  
  path '/users/sessions/validate' do
    post 'validate user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          mobile_number: { type: :string },
          code: { type: :string },
        },
        required: %w(mobile_number code)
      }

      response '200', 'user validated' do
        let(:code) { '1234' }
        let(:user) do
          { user: {
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

      response '422', 'user invalidated' do
        let(:code) { '1234' }
        let(:user) do
          { user: {
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
