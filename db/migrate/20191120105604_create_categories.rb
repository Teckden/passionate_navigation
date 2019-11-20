class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.references :vertical, null: false, foreign_key: true
      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
