# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'json'

JSON.load(Rails.root.join('db/data/verticals.json')).each do |row|
  Vertical.find_or_create_by!(name: row['Name'], id: row['Id'])
end

JSON.load(Rails.root.join('db/data/categories.json')).each do |row|
  Category.find_or_create_by!(name: row['Name'], state: row['State'], vertical_id: row['Verticals'])
end

JSON.load(Rails.root.join('db/data/courses.json')).each do |row|
  Course.find_or_create_by!(
    name:        row['Name'],
    state:       row['State'],
    author:      row['Author'],
    category_id: row['Categories']
  )
end
