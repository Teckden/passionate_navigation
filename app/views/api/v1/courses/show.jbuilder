json.links do
  json.self api_v1_category_course_path(category_id: @course.category_id, id: @course.id)
end
json.data @course, partial: 'course', as: :course
