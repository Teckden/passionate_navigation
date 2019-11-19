require 'swagger_helper'

RSpec.describe "Api V1 Verticals" do
  path '/api/v1/verticals' do
    get 'Retrieves the list of verticals' do
      tags 'Verticals'

      response '200', 'Returns the list of verticals' do
        schema "$ref" => "#/definitions/verticals/index/success"

        examples 'application/json' => {
          meta: { total: 5 },
          links: { self: '/api/v1/verticals' },
          data: [{
                   type: 'verticals',
                   id: 2,
                   attributes: { name: 'Music' },
                 }]
        }
        before { FactoryBot.create(:vertical, name: 'Music') }

        run_test! do |response|
          vertical_name = JSON.parse(response.body).dig('data', 0, 'attributes', 'name')
          expect(vertical_name).to eq('Music')
        end
      end
    end

    post 'Creates a vertical record' do
      tags 'Verticals'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :vertical, in: :body, schema: {
        type: :object,
        properties: {
          vertical: {
            type:       :object,
            required:   %w(name),
            properties: { name:   { type: :string } }
          }
        },
        required: [ 'vertical' ]
      }

      response '201', 'Creates vertical record' do
        let(:vertical) { { vertical: { name: 'Music' } } }
        schema '$ref' => '#definitions/verticals/show/success'

        examples 'application/json' => {
          links: { self: '/api/v1/verticals/2' },
          data: { type: 'verticals', id: 2, attributes: { name: 'Music' } }
        }
        run_test! do |response|
          vertical_name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(vertical_name).to eq('Music')
        end
      end

      response '422', 'Fails to create vertical record' do
        let(:vertical) { { vertical: { name: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Name cannot be blank' }] }

        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq('Name can\'t be blank')
        end
      end
    end
  end

  path '/api/v1/verticals/{id}' do
    get 'Retrieves the vertical record' do
      tags 'Verticals'
      produces 'application/json'
      parameter name: :id, in: :path, schema: { type: :string }, description: 'Vertical Id'

      response '200', 'Retrieves vertical record' do
        let(:id) { FactoryBot.create(:vertical).id }

        examples 'application/json' => {
          links: { self: '/api/v1/verticals/1' },
          data:  { type: 'verticals', id: 2, attributes: { name: 'Music' } }
        }
        run_test!
      end

      response '404', 'Fails if vertical record cannot be found' do
        let(:id) { 404 }

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end

    patch 'Updates the vertical record' do
      tags 'Verticals'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, schema: { type: :string }, description: 'Vertical Id'
      parameter name: :vertical, in: :body, schema: {
        type: :object,
        properties: {
          vertical: {
            type:       :object,
            properties: { name:  { type: :string } }
          }
        },
        required: [ 'vertical' ]
      }

      response '200', 'Updates vertical record' do
        let(:id)       { FactoryBot.create(:vertical).id }
        let(:vertical) { { vertical: { name: 'New Name' } } }
        schema '$ref' => '#definitions/verticals/show/success'

        examples 'application/json' => {
          links: { self: '/api/v1/verticals/1' },
          data:  { type: 'verticals', id: 2, attributes: { name: 'New Name' } }
        }

        run_test! do |response|
          new_name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(new_name).to eq('New Name')
        end
      end

      response '422', 'Fails to update vertical record due to validation errors' do
        let(:id)      { FactoryBot.create(:vertical).id }
        let(:vertical) { { vertical: { name: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Name cannot be blank' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Name can't be blank")
        end
      end

      response '404', 'Fails to find vertical' do
        let(:id)       { 404 }
        let(:vertical) { { vertical: { name: 'New Name' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end

    delete 'Deletes the vertical record' do
      tags 'Verticals'
      consumes 'application/json'
      parameter name: :id, in: :path, schema: { type: :string }, description: 'Vertical Id'

      response '204', 'Deletes the vertical record and returns no content' do
        let(:id) { FactoryBot.create(:vertical).id }
        run_test! { |response| expect(response.body).to be_empty }
      end

      response '404', 'Fails to delete if vertical cannot be found' do
        let(:id) { 404 }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end
  end
end
