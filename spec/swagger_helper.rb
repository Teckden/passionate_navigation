require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      definitions: {
        errors: {
          "type": "object",
          "required": ["errors"],
          "properties": {
            "errors": {
              "type": "array",
              "items": {
                "type": "object",
                "required": ["title"],
                "properties": { "title": { "type": "string" } }
              }
            }
          }
        },
        verticals: {
          vertical: JSON.load(Rails.root.join('spec/support/schemas/api/v1/verticals/_vertical.json')),
          index: {
            success: JSON.load(Rails.root.join('spec/support/schemas/api/v1/verticals/index.json'))
          },
          show: {
            success: JSON.load(Rails.root.join('spec/support/schemas/api/v1/verticals/show.json'))
          }
        },
        categories: {
          category: JSON.load(Rails.root.join('spec/support/schemas/api/v1/categories/_category.json')),
          index: {
            success: JSON.load(Rails.root.join('spec/support/schemas/api/v1/categories/index.json'))
          },
          show: {
            success: JSON.load(Rails.root.join('spec/support/schemas/api/v1/categories/show.json'))
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
