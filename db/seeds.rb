random_password = SecureRandom.hex(10)
admin = Admin.create(name: 'admin', email: 'admin@mail.com', password: random_password)
puts "Admin created with email: admin and password: #{random_password}"
