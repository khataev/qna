FactoryGirl.define do
  factory :vote do
    user

    factory :like_vote do
      like true
    end

    factory :dislike_vote do
      like false
    end
  end
end
