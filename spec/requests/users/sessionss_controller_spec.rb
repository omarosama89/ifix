require 'swagger_helper'

describe 'users/sessions', type: :request do
  path '/users/sessions/login' do
    post 'login user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              mobile_number: { type: :string }
            }
          }
        },
        required: %w(mobile_number)
      }

      response '200', 'user created' do
        let(:mobile_number) { Faker::PhoneNumber.subscriber_number(length: 11) }
        let!(:user_record) { FactoryBot.create(:user, mobile_number: mobile_number) }
        let(:user) do
          { user: {
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
        let(:user) do
          {
            user: {
              mobile_number: '12345xx'
            }
          }
        end

        let(:result) { {"success"=>false, "errors"=>"user not found"} }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(result)
        end
      end
    end
  end
  
  path '/users/sessions/validate' do
    post 'validate user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              mobile_number: { type: :string },
              code: { type: :string },
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
