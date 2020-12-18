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
      t.string :comments

      t.string :street
      t.string :colony
      t.string :zc
      t.string :city
      t.string :state

      t.string :actions_taken
      t.string :guide_id
      t.string :parcel
      t.boolean :free_guide, default: false

      t.timestamps
    end

    add_index :devolutions, :rma, unique: true
    add_index :devolutions, :email
    add_index :devolutions, :order_id
  end
end
