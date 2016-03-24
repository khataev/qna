FactoryGirl.define do
  sequence :email do |n|
    "email-#{n}@example.com"
  end

  factory :user, aliases: [:author] do
    email
    password '1234567890'
    password_confirmation '1234567890'
    confirmed_at Time.now
  end
end
