class CreateShipmentProductDestinations < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_product_destinations do |t|
      t.references :shipment_product, null: false, foreign_key: true
      t.string :destination
      t.integer :units

      t.timestamps
    end
  end
end
