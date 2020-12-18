class SeparateDevolutionAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :devolutions, :street, :string, after: :comments
    add_column :devolutions, :colony, :string, after: :street
    add_column :devolutions, :zc, :string, after: :colony
    add_column :devolutions, :city, :string, after: :zc
    add_column :devolutions, :state, :string, after: :city

    Devolution.all.each do |dev|
      next unless dev.devolution_address.present?
      addr = dev.devolution_address.split(/\n/)
      dev.street = addr[0].strip
      dev.colony = addr[1].strip
      dev.zc = addr[2].strip
      dev.city = addr[3].split(',')[0].strip
      dev.state = addr[3].split(',')[1].strip
      unless dev.save
        puts "// unable to separate dev #{dev.id}, #{dev.rma}, #{dev.order_id} //"
        puts "// zc: '#{zc}' //"
        puts "** errors #{dev.errors.to_json} **"
      end
    end
  end
end
