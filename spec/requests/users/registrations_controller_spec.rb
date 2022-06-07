require 'swagger_helper'

describe 'users/registrations', type: :request do
  path '/users/registrations/sign_up' do
    post 'Sign up user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              mobile_number: { type: :string }
            }
          }
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

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)
          expect(User.count).to be(1)
        end
      end

      response '422', 'unprocessable entity' do
        let(:user) do
          {
            user: {
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
  
  path '/users/registrations/validate' do
    post 'validate user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              mobile_number: { type: :string },
              code: { type: :string }
            }
          }
        },
        required: %w(mobile_number code)
      }

      response '200', 'user validated' do
        let(:code) { '1234' }
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let!(:user_record) { FactoryBot.create(:user, mobile_number: mobile_number) }
        let(:user) do
          { user: {
              mobile_number: mobile_number,
              code: code
            }
          }
        end
        
        before do
          allow(CodeAuthenticator).to receive(:check).with(code, nil).and_return(true)
        end

        run_test! do
          user_record.reload

          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)

          headers = response.headers
          expect(headers['ifix-uid']).to eq(user_record.id)
          expect(headers['ifix-mobile-number']).to eq(user_record.mobile_number)
          expect(headers['ifix-token']).to eq(user_record.token)
          expect(headers['ifix-reset-token']).to eq(user_record.reset_token)
        end
      end

      response '422', 'user invalidated' do
        let(:code) { '1234' }
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let!(:user_record) { FactoryBot.create(:user, mobile_number: mobile_number) }
        let(:user) do
          { user: {
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
