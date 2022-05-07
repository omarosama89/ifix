require 'swagger_helper'

describe 'users/registrations', type: :request do
  path '/users/registrations/sign_up' do
    post 'Sign up user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          mobile_number: { type: :string }
        },
        required: %w(first_name last_name mobile_number)
      }

      response '201', 'user created' do
        let(:user) do
          { user: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              mobile_number: Faker::PhoneNumber.subscriber_number(length: 11)
            }
          }
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:user) do
          {
            user: {
              first_name: Faker::Name.first_name
            }
          }
        end

        run_test!
      end
    end
  end
  
  path '/users/registrations/validate' do
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
