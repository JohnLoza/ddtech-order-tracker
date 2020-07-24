class CreateMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :movements do |t|
      t.references :user
      t.references :order
      t.string :description
      t.string :data
      t.timestamps
    end
  end
end
