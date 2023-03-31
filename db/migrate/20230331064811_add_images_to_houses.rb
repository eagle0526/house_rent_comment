class AddImagesToHouses < ActiveRecord::Migration[7.0]
  def change
    add_column :houses, :images, :string
  end
end
