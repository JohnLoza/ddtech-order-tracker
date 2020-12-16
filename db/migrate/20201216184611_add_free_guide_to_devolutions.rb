class AddFreeGuideToDevolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :devolutions, :free_guide, :boolean,
      default: false, after: :parcel
  end
end
