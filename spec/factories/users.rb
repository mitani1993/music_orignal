FactoryBot.define do
  factory :user do
    name              {Faker::Name}
    email                 {Faker::Internet.free_email}
    password              {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
    area_id               {Faker::Number.within(range: 2..10)}
    profession_id         {Faker::Number.within(range: 2..4)}
    profile               {Faker::Lorem.sentence}
    youtube               {Faker::Internet.url}

    after(:build) do |user|
      user.image.attach(io: File.open('app/assets/images/no_image.png'), filename: 'no_images.png')
    end
  end
end