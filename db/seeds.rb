# Seed initial Admin user
admin = User.find_or_initialize_by(email: "admin@example.com")
admin.assign_attributes(
  name: "System Admin",
  password: "password123",
  password_confirmation: "password123",
  role: "admin",
  billing_day: 1
)
admin.save!
puts "Admin user created: #{admin.email}"
