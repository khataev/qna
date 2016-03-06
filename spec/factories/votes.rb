FactoryGirl.define do
  factory :vote do
    user

    factory :like_vote do
      value true
    end

    factory :dislike_vote do
      value false
    end
  end
end
