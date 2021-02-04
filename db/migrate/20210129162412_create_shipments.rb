class CreateShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :shipments do |t|
      t.string :hash_id
      t.references :origin_state, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.datetime :estimated_arrival
      t.string :comments
      t.string :status

      t.timestamps
    end
  end
end
