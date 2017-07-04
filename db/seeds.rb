User.create!(name:  "El Usuarito",
            username:"elusuarito",
            email: "example@railstutorial.org",
            password:              "123456789",
            password_confirmation: "123456789",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

User.create!(name:  "El JA",
            username:"elja",
            email: "javieitez@grupocmc.es",
            password:              "123456789",
            password_confirmation: "123456789",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  username = name.downcase.tr('^A-Za-z0-9', '')
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              username: username,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end