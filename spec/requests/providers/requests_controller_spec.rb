require 'swagger_helper'

describe 'providers/requests', type: :request do
  path '/providers/requests/{id}/accept' do
    put 'accept request' do
      consumes 'application/json'
      parameter name: 'ifix-uid', in: :header, type: :string, required: true
      parameter name: 'ifix-token', in: :header, type: :string, required: true
      parameter name: 'ifix-mobile-number', in: :header, type: :string, required: true

      parameter name: :id, in: :path

      response '200', 'request accepted' do
        let!(:provider) { FactoryBot.create(:provider) }
        let!(:request) { FactoryBot.create(:request) }
        let!(:request_details) { FactoryBot.create_list(:request_detail, 2, request: request) }

        let(:'ifix-uid') { provider.id }
        let(:'ifix-mobile-number') { provider.mobile_number }
        let(:'ifix-token') { provider.token }

        let(:id) { request.id }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)
          expect(request.reload.status).to eq(Request::STATUSES[:accepted])
        end
      end

      response '401', 'unauthorized' do
        let!(:provider) { FactoryBot.create(:provider) }
        let!(:request) { FactoryBot.create(:request) }
        let!(:request_details) { FactoryBot.create_list(:request_detail, 2, request: request) }

        let(:'ifix-uid') { 'xx' }
        let(:'ifix-mobile-number') { 'xx' }
        let(:'ifix-token') { 'xx' }

        let(:id) { request.id }

        let(:result) { {"success"=>false, "errors"=>"unauthorized"} }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(result)
        end
      end
    end
  end

  path '/providers/requests/{id}/process_request' do
    put 'accept request' do
      consumes 'application/json'
      parameter name: 'ifix-uid', in: :header, type: :string, required: true
      parameter name: 'ifix-token', in: :header, type: :string, required: true
      parameter name: 'ifix-mobile-number', in: :header, type: :string, required: true

      parameter name: :id, in: :path

      response '200', 'request processing' do
        let!(:provider) { FactoryBot.create(:provider) }
        let!(:request) { FactoryBot.create(:request, :accepted) }
        let!(:request_details) { FactoryBot.create_list(:request_detail, 2, request: request) }

        let(:'ifix-uid') { provider.id }
        let(:'ifix-mobile-number') { provider.mobile_number }
        let(:'ifix-token') { provider.token }

        let(:id) { request.id }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)
          expect(request.reload.status).to eq(Request::STATUSES[:processing])
        end
      end

      response '401', 'unauthorized' do
        let!(:provider) { FactoryBot.create(:provider) }
        let!(:request) { FactoryBot.create(:request) }
        let!(:request_details) { FactoryBot.create_list(:request_detail, 2, request: request) }

        let(:'ifix-uid') { 'xx' }
        let(:'ifix-mobile-number') { 'xx' }
        let(:'ifix-token') { 'xx' }

        let(:id) { request.id }

        let(:result) { {"success"=>false, "errors"=>"unauthorized"} }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(result)
        end
      end
    end
  end

  path '/providers/requests/{id}/complete' do
    put 'accept request' do
      consumes 'application/json'
      parameter name: 'ifix-uid', in: :header, type: :string, required: true
      parameter name: 'ifix-token', in: :header, type: :string, required: true
      parameter name: 'ifix-mobile-number', in: :header, type: :string, required: true

      parameter name: :id, in: :path

      response '200', 'request accepted' do
        let!(:provider) { FactoryBot.create(:provider) }
        let!(:request) { FactoryBot.create(:request, :processing) }
        let!(:request_details) { FactoryBot.create_list(:request_detail, 2, request: request) }

        let(:'ifix-uid') { provider.id }
        let(:'ifix-mobile-number') { provider.mobile_number }
        let(:'ifix-token') { provider.token }

        let(:id) { request.id }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['success']).to eq(true)
          expect(request.reload.status).to eq(Request::STATUSES[:completed])
        end
      end

      response '401', 'unauthorized' do
        let!(:provider) { FactoryBot.create(:provider) }
        let!(:request) { FactoryBot.create(:request) }
        let!(:request_details) { FactoryBot.create_list(:request_detail, 2, request: request) }

        let(:'ifix-uid') { 'xx' }
        let(:'ifix-mobile-number') { 'xx' }
        let(:'ifix-token') { 'xx' }

        let(:id) { request.id }

        let(:result) { {"success"=>false, "errors"=>"unauthorized"} }

        run_test! do
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to eq(result)
        end
      end
    end
  end
end
