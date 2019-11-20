json.type 'categories'
json.id category.id

json.attributes do
  json.name category.name
  json.state category.state
end

json.relationships do
  json.vertical do
    json.links { json.self api_v1_vertical_path(id: category.vertical_id) }
    json.data do
      json.type 'verticals'
      json.id category.vertical_id
    end
  end
end
