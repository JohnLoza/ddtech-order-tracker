class DropDevolutionAddressField < ActiveRecord::Migration[6.0]
  def change
    remove_column :devolutions, :devolution_address
  end
end
