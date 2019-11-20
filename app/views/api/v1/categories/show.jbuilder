json.links { json.self api_v1_vertical_category_path(vertical_id: @category.vertical_id, id: @category.id) }

json.data @category, partial: 'category', as: :category
