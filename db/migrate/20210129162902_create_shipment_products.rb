class CreateShipmentProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_products do |t|
      t.references :shipment, null: false, foreign_key: true
      t.string :ddtech_id

      t.timestamps
    end
  end
end
