require 'swagger_helper'

describe 'Api V1 Courses' do
  path '/api/v1/categories/{category_id}/courses' do
    get 'Retrieves the list of courses that belong to the category' do
      tags 'Category Courses'
      parameter name: :category_id, in: :path, schema: { type: :string },
                description: 'Category ID'

      response '200', 'List of courses' do
        let(:category) { FactoryBot.create(:category, :with_courses) }
        let(:category_id) { category.id }
        schema "$ref" => "#/definitions/courses/index/success"

        examples 'application/json' => {
          meta: { total: 5 },
          links: { self: '/api/v1/categories/1/courses' },
          data: [{
                   type: 'courses',
                   id: 2,
                   attributes: { name: 'Build a Wild Audience', state: 'active', author: 'Harry' },
                   relationships: {
                     category: {
                       links: { self: '/api/v1/categories/1' },
                       data: { type: 'categories', id: 1 }
                     }
                   }
                 }]
        }

        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 0, 'attributes', 'name')
          expect(name).to eq(category.courses.first.name)
        end
      end

      response '404', 'Fails to find category record' do
        let(:category_id) { 404 }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Category with 'id'=404")
        end
      end
    end

    post 'Creates a course record' do
      tags 'Category Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :category_id, in: :path, schema: { type: :string },
                description: 'Category ID'
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          course: {
            type:       :object,
            required:   %w(name state author),
            properties: {
              name:   { type: :string },
              state:  { type: :string },
              author: { type: :string }
            }
          }
        },
        required: [ 'course' ]
      }

      response '201', 'Creates course record under category scope' do
        let(:category_id) { FactoryBot.create(:category).id }
        let(:course) { { course: { name: 'Build Audience', state: 'active', author: 'Harry' } } }
        schema '$ref' => '#definitions/courses/show/success'

        examples 'application/json' => {
          links: { self: '/api/v1/categories/1/courses/2' },
          data: {
            type: 'courses',
            id: 2,
            attributes: { name: 'Build Audience', state: 'active', author: 'Harry' },
            relationships: {
              category: {
                links: { self: '/api/v1/categories/1' },
                data: { type: 'categories', id: 1 }
              }
            }
          }
        }
        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(name).to eq('Build Audience')
        end
      end

      response '422', 'Fails to create course record' do
        let(:category_id) { FactoryBot.create(:category).id }
        let(:course)      { { course: { name: '', state: '', author: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Name cannot be blank' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq('Name can\'t be blank')
        end
      end

      response '404', 'Fails to find category record' do
        let(:category_id) { 404 }
        let(:course) { { course: { name: '', state: '', author: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Category with 'id'=404")
        end
      end
    end
  end

  path '/api/v1/categories/{category_id}/courses/{id}' do
    get 'Retrieves the course record' do
      tags 'Category Courses'
      produces 'application/json'
      parameter name: :category_id, in: :path, schema: { type: :string },
                description: 'Category ID'
      parameter name: :id, in: :path, schema: { type: :string },
                description: 'Course ID'

      response '200', 'Retrieves course record' do
        let(:category_id) { FactoryBot.create(:category).id }
        let(:id) { FactoryBot.create(:course, category_id: category_id, name: 'Build Audience').id }

        examples 'application/json' => {
          links: { self: '/api/v1/categories/1/courses/2' },
          data: {
            type: 'courses',
            id: 2,
            attributes: { name: 'Build Audience', state: 'active', author: 'Harry' },
            relationships: {
              category: {
                links: { self: '/api/v1/categories/1' },
                data: { type: 'categories', id: 1 }
              }
            }
          }
        }
        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(name).to eq('Build Audience')
        end
      end

      response '404', 'Fails if category or course record cannot be found' do
        let(:category_id) { 404 }
        let(:id) { 404 }

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Category with 'id'=404")
        end
      end
    end

    patch 'Updates the course record' do
      tags 'Category Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :category_id, in: :path, schema: { type: :string },
                description: 'Category ID'
      parameter name: :id, in: :path, schema: { type: :string },
                description: 'Course ID'
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          course: {
            type:       :object,
            properties: {
              name:  { type: :string },
              state: { type: :string }
            }
          }
        },
        required: [ 'course' ]
      }

      response '200', 'Updates course record' do
        let(:category)    { FactoryBot.create(:category, :with_courses) }
        let(:category_id) { category.id }
        let(:id)          { category.courses.first.id }
        let(:course)      { { course: { name: 'New Name' } } }
        schema '$ref' => '#definitions/categories/show/success'

        examples 'application/json' => {
          links: { self: '/api/v1/categories/1/courses/2' },
          data: {
            type: 'courses',
            id: 2,
            attributes: { name: 'Build Audience', state: 'active', author: 'Harry' },
            relationships: {
              category: {
                links: { self: '/api/v1/categories/1' },
                data: { type: 'categories', id: 1 }
              }
            }
          }
        }
        run_test! do |response|
          name = JSON.parse(response.body).dig('data', 'attributes', 'name')
          expect(name).to eq('New Name')
        end
      end

      response '422', 'Fails to update course record due to validation errors' do
        let(:category)    { FactoryBot.create(:category, :with_courses) }
        let(:category_id) { category.id }
        let(:id)          { category.courses.first.id }
        let(:course)      { { course: { name: '' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Name cannot be blank' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq('Name can\'t be blank')
        end
      end

      response '404', 'Fails to find category or course' do
        let(:category_id) { 404 }
        let(:id)          { 404 }
        let(:course)      { { course: { name: 'New Name' } } }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Category with 'id'=404")
        end
      end
    end

    delete 'Deletes the course record' do
      tags 'Category Courses'
      consumes 'application/json'
      parameter name: :category_id, in: :path, schema: { type: :string },
                description: 'Category ID'
      parameter name: :id, in: :path, schema: { type: :string },
                description: 'Course ID'

      response '204', 'Deletes the course record and returns no content' do
        let(:category_id) { FactoryBot.create(:category).id }
        let(:id)          { FactoryBot.create(:course, category_id: category_id).id }

        run_test! do |response|
          expect(response.body).to be_empty
        end
      end

      response '404', 'Fails to delete if category or course cannot be found' do
        let(:category_id) { 404 }
        let(:id)          { 404 }
        schema '$ref' => '#/definitions/errors'

        examples 'application/json' => { errors: [{ title: 'Not found error' }] }
        run_test! do |response|
          error = JSON.parse(response.body).dig('errors', 0, 'title')
          expect(error).to eq("Couldn't find Category with 'id'=404")
        end
      end
    end
  end
end
