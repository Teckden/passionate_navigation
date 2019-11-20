json.meta  { json.total @courses.size }
json.links do
  json.self api_v1_category_courses_path(category_id: params[:category_id])
end

json.data do
  json.array! @courses, partial: 'course', as: :course
end
