class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.references :user
      t.references :order
      t.text :message
      t.timestamps
    end
  end
end
