class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :css_class
      t.timestamps
    end

    create_table :order_tags do |t|
      t.references :order
      t.references :tag
    end
  end
end
