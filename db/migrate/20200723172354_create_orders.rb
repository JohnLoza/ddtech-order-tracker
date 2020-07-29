class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.string :ddtech_key, unique: true
      t.string :client_email
      t.string :status
      t.string :parcel
      t.string :guide
      t.boolean :assemble, default: false
      t.boolean :holding, default: false
      t.timestamps
    end

    add_index :orders, :ddtech_key, unique: true
    add_index :orders, :client_email
    add_index :orders, :status
  end
end
