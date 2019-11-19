json.errors do
  json.array! @errors.each do |error|
    json.title error
  end
end
