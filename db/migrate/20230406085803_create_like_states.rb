class CreateLikeStates < ActiveRecord::Migration[7.0]
  def change
    create_table :like_states do |t|
      t.boolean :state
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
