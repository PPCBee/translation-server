require 'rails_helper'

module API
  module V1
    describe 'API controller blocks post requests from restricted ips',
             type: :request do
      let!(:restricted_ip) { create :restricted_ip, ip: '192.168.0.0/24' }

      context 'headers include Original-IP-Address' do
        let(:headers) do
          {
            'Original-IP-Address' => '192.168.0.1'
          }
        end

        it 'responds with forbidden when ip is in range' do
          post '/api/v1/translations', nil, headers

          expect(response.status).to eq 403
        end

        it 'GET requests are not affected' do
          get '/api/v1/translations', nil, headers

          expect(response.status).to_not eq 403
        end

        it 'doesnt respond with forbidden when ip isnt in range' do
          headers = {
            'Original-IP-Address' => '192.168.99.1'
          }
          post '/api/v1/translations', nil, headers

          expect(response.status).to_not eq 403
        end
      end

      context 'headers dont include Original-IP-Address' do
        it 'responds with forbidden when ip is in range' do
          post '/api/v1/translations', nil, 'REMOTE_ADDR' => '192.168.0.1'

          expect(response.status).to eq 403
        end

        it 'doesnt respond with forbidden when ip isnt in range' do
          post '/api/v1/translations', nil, 'REMOTE_ADDR' => '192.168.99.1'

          expect(response.status).to_not eq 403
        end
      end
    end
  end
end
