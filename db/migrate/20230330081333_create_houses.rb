class CreateHouses < ActiveRecord::Migration[7.0]
  def change
    create_table :houses do |t|
      t.string :title
      t.text :description
      t.string :tel
      t.string :address
      t.string :owner
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
