class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.string :author, null: false
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
