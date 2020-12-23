class AddVoucherFolioToDevolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :devolutions, :voucher_folio, :string, after: :parcel
    add_column :devolutions, :voucher_amount, :decimal, precision: 8, scale: 2, after: :voucher_folio
  end
end
