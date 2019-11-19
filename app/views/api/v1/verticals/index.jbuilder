json.meta  { json.total @verticals.size }
json.links { json.self api_v1_verticals_path }

json.data do
  json.array! @verticals, partial: 'vertical', as: :vertical
end
