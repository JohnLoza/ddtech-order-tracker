# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if User.all.empty?
  (1..5).each do |subfix|
    User::ROLES.keys.each do |role|
      User.create(
        name: "#{I18n.t("user.roles.#{role}")}_#{subfix}",
        email: "#{role}#{subfix}@mail.com",
        role: role,
        password: 'foobar',
        password_confirmation: 'foobar'
      )
    end
  end
end
