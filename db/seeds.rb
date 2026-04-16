# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creando usuario..."
user_params = {
  email: "ycarvajalq@gmail.com",
  password: "12345678",
  password_confirmation: "12345678"
}

user = User.create!(user_params)
puts "Usuario creado: #{user.email}"


social_ecological_characterizations_params = [
  {
    authors: "#{Faker::Book.author}, #{Faker::Book.author}",
    year: Faker::Number.between(from: 1900, to: Time.now.year),
    title: Faker::Book.title,
    resource_type: rand(1..5),
    institution: Faker::Company.name,
    url: Faker::Internet.url,
    access_level: rand(1..3),
    geographic_area: rand(1..4),
    spatial_coverage: rand(1..3),
    analysis_scale: rand(1..3),
    study_period: Faker::Lorem.sentence,
    study_objective: Faker::Lorem.sentence,
    approach: rand(1..3),
    general_methodology_used: Faker::Lorem.sentence,
    user_id: user.id
  },
  {
    authors: "#{Faker::Book.author}, #{Faker::Book.author}",
    year: Faker::Number.between(from: 1900, to: Time.now.year),
    title: Faker::Book.title,
    resource_type: rand(1..5),
    institution: Faker::Company.name,
    url: Faker::Internet.url,
    access_level: rand(1..3),
    geographic_area: rand(1..4),
    spatial_coverage: rand(1..3),
    analysis_scale: rand(1..3),
    study_period: Faker::Lorem.sentence,
    study_objective: Faker::Lorem.sentence,
    approach: rand(1..3),
    general_methodology_used: Faker::Lorem.paragraph,
    user_id: user.id
  },
  {
    authors: "#{Faker::Book.author}, #{Faker::Book.author}",
    year: Faker::Number.between(from: 1900, to: Time.now.year),
    title: Faker::Book.title,
    resource_type: rand(1..5),
    institution: Faker::Company.name,
    url: Faker::Internet.url,
    access_level: rand(1..3),
    geographic_area: rand(1..4),
    spatial_coverage: rand(1..3),
    analysis_scale: rand(1..3),
    study_period: Faker::Lorem.sentence,
    study_objective: Faker::Lorem.sentence,
    approach: rand(1..3),
    general_methodology_used: Faker::Lorem.paragraph,
    user_id: user.id
  }
]

puts "Creando registros de pruba..."
social_ecological_characterizations_params.each do |params|
  SocialEcologicalCharacterization.create!(params)
end

puts "Registros creados exitosamente."
