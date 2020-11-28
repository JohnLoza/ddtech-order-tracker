class CreateDevolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :devolutions do |t|
      t.references :user
      t.string :rma, unique: true

      t.string :client_name
      t.string :email
      t.string :telephone
      t.string :client_type

      t.string :order_id
      t.string :products
      t.string :description
      t.string :devolution_address
      t.string :comments

      t.string :actions_taken
      t.integer :guide_id
      t.string :parcel

      t.timestamps
    end

    add_index :devolutions, :rma, unique: true
    add_index :devolutions, :email
    add_index :devolutions, :order_id
  end
end
