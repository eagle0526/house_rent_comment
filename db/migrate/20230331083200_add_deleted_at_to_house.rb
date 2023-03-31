class AddDeletedAtToHouse < ActiveRecord::Migration[7.0]
  def change
    add_column :houses, :deleted_at, :datetime
    add_index :houses, :deleted_at
  end
end
