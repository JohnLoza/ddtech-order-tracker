class CreateOriginStates < ActiveRecord::Migration[6.0]
  def change
    create_table :origin_states do |t|
      t.string :name
      t.integer :estimated_shipment_days

      t.timestamps
    end
  end
end
