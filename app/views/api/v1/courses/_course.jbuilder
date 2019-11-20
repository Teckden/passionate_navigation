json.type 'courses'
json.id course.id

json.attributes do
  json.name course.name
  json.state course.state
  json.author course.author
end

json.relationships do
  json.category do
    json.links do
      json.self api_v1_vertical_category_path(vertical_id: course.category.vertical_id,
                                              id:          course.category_id)
    end

    json.data do
      json.type 'categories'
      json.id course.category_id
    end
  end
end
