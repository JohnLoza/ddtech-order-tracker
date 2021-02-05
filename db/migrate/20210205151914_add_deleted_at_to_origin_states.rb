class AddDeletedAtToOriginStates < ActiveRecord::Migration[6.0]
  def change
    add_column :origin_states, :deleted_at, :datetime, after: :estimated_shipment_days
  end
end
