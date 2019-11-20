json.meta  { json.total @categories.size }
json.links { json.self api_v1_vertical_categories_path(vertical_id: params[:vertical_id]) }

json.data do
  json.array! @categories, partial: 'category', as: :category
end
