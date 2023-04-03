class AddSlugToHouses < ActiveRecord::Migration[7.0]
  def change
    add_column :houses, :slug, :string
    add_index :houses, :slug, unique: true
  end
end
