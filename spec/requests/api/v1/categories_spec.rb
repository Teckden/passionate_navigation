require 'swagger_helper'

RSpec.describe "Api V1 Categories" do
  path '/api/v1/verticals/{vertical_id}/categories' do
    get 'Retrieves the list of categories that belong to the vertical' do
      tags 'Vertical Categories'
      parameter name: :vertical_id, in: :path, schema: { type: :string },
                description: 'Id of the Vertical record'

      response '200', 'List of categories' do
        let(:vertical) { FactoryBot.create(:vertical, :with_categories) }
        let(:vertical_id) { vertical.id }
        schema "$ref" => "#/definitions/categories/index/success"

        examples 'application/json' => {
          meta: { total: 5 },
          links: { self: '/api/v1/verticals/1/categories' },
          data: [{
                   type: 'categories',
                   id: 2,
                   attributes: { name: 'Booty & Abs', state: 'active' },
                   relationships: {
                     vertical: {
                       links: { self: '/api/v1/vertical/1' },
                       data: { type: 'verticals', id: 1 }
                     }
                   }
                 }]
        }

        before { vertical.categories.first.update(name: 'Booty & Abs') }

        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 0, 'attributes', 'name')
          expect(name).to eq('Booty & Abs')
        end
      end

      response '404', 'Fails to find vertical record' do
        let(:vertical_id) { 404 }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }

        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end

    post 'Creates a category record' do
      tags 'Vertical Categories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :vertical_id, in: :path, schema: { type: :string },
                description: 'Vertical ID'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type:       :object,
            required:   %w(name state),
            properties: {
              name:  { type: :string },
              state: { type: :string }
            }
          }
        },
        required: [ 'category' ]
      }

      response '201', 'Creates category record under vertical scope' do
        let(:vertical_id) { FactoryBot.create(:vertical).id }
        let(:category) { { category: { name: 'Booty & Abs', state: 'active' } } }
        schema '$ref' => '#definitions/categories/show/success'

        examples 'application/json' => {
          links: { self: '/api/v1/verticals/1/categories/2' },
          data: {
            type: 'categories',
            id: 2,
            attributes: { name: 'Booty & Abs', state: 'active' },
            relationships: {
              vertical: {
                links: { self: '/api/v1/vertical/1' },
                data: { type: 'verticals', id: 1 }
              }
            }
          }
        }
        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(name).to eq('Booty & Abs')
        end
      end

      response '422', 'Fails to create category record' do
        let(:vertical_id) { FactoryBot.create(:vertical).id }
        let(:category) { { category: { name: '', state: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Name cannot be blank' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq('Name can\'t be blank')
        end
      end

      response '404', 'Fails to find vertical record' do
        let(:vertical_id) { 404 }
        let(:category) { { category: { name: '', state: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end
  end

  path '/api/v1/verticals/{vertical_id}/categories/{id}' do
    get 'Retrieves the category record' do
      tags 'Vertical Categories'
      produces 'application/json'
      parameter name: :vertical_id, in: :path, schema: { type: :string },
                description: 'Vertical ID'
      parameter name: :id, in: :path, schema: { type: :string },
                description: 'Category ID'

      response '200', 'Retrieves category record' do
        let(:vertical_id) { FactoryBot.create(:vertical).id }
        let(:id) { FactoryBot.create(:category, vertical_id: vertical_id, name: 'Booty & Abs').id }

        examples 'application/json' => {
          links: { self: '/api/v1/verticals/1/categories/2' },
          data: {
            type: 'categories',
            id: 2,
            attributes: { name: 'Booty & Abs', state: 'active' },
            relationships: {
              vertical: {
                links: { self: '/api/v1/vertical/1' },
                data: { type: 'verticals', id: 1 }
              }
            }
          }
        }
        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(name).to eq('Booty & Abs')
        end
      end

      response '404', 'Fails if vertical or category record cannot be found' do
        let(:vertical_id) { 404 }
        let(:id) { 404 }

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end

    patch 'Updates the category record' do
      tags 'Vertical Categories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :vertical_id, in: :path, schema: { type: :string },
                description: 'Vertical ID'
      parameter name: :id, in: :path, schema: { type: :string },
                description: 'Category ID'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type:       :object,
            properties: {
              name:  { type: :string },
              state: { type: :string }
            }
          }
        },
        required: [ 'category' ]
      }

      response '200', 'Updates category record' do
        let(:vertical)    { FactoryBot.create(:vertical, :with_categories) }
        let(:vertical_id) { vertical.id }
        let(:id)          { vertical.categories.first.id }
        let(:category)    { { category: { name: 'New Name' } } }
        schema '$ref' => '#definitions/categories/show/success'

        examples 'application/json' => {
          links: { self: '/api/v1/verticals/1/categories/2' },
          data: {
            type: 'categories',
            id: 2,
            attributes: { name: 'Booty & Abs', state: 'active' },
            relationships: {
              vertical: {
                links: { self: '/api/v1/vertical/1' },
                data: { type: 'verticals', id: 1 }
              }
            }
          }
        }
        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(name).to eq('New Name')
        end
      end

      response '422', 'Fails to update category record due to validation errors' do
        let(:vertical)    { FactoryBot.create(:vertical, :with_categories) }
        let(:vertical_id) { vertical.id }
        let(:id)          { vertical.categories.first.id }
        let(:category)    { { category: { name: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Name cannot be blank' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq('Name can\'t be blank')
        end
      end

      response '404', 'Fails to find vertical or category' do
        let(:vertical_id) { 404 }
        let(:id)          { 404 }
        let(:category) { { category: { name: '', state: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end

    delete 'Deletes the category record' do
      tags 'Vertical Categories'
      consumes 'application/json'
      parameter name: :vertical_id, in: :path, schema: { type: :string },
                description: 'Vertical ID'
      parameter name: :id, in: :path, schema: { type: :string },
                description: 'Category ID'

      response '204', 'Deletes the category record and returns no content' do
        let(:vertical_id) { FactoryBot.create(:vertical).id }
        let(:id)          { FactoryBot.create(:category, vertical_id: vertical_id).id }

        run_test! do |response|
          expect(response.body).to be_empty
        end
      end

      response '404', 'Fails to delete if vertical or category cannot be found' do
        let(:vertical_id) { 404 }
        let(:id)          { 404 }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Vertical with 'id'=404")
        end
      end
    end
  end
end
