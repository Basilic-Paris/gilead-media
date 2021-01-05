puts 'Destroying'
User.destroy_all

puts "Seeding Users"
users_attributes = [
  { email: 'alice.fabre@hotmail.fr', first_name: 'Alice', last_name: 'Fabre', password: 'plopplop', admin: true },
  { email: 'gregory@cookoon.fr', first_name: 'Grégory', last_name: 'Escure', password: 'plopplop' },
]
User.create! users_attributes
puts "Users done"
