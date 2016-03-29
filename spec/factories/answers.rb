FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }
    author
    question

    transient do
      vote_author :user
    end

    factory :answer_with_file do
      after(:create) do |answer|
        create(:attachment, attachable: answer)
      end
    end

    factory :answer_with_positive_vote do
      after(:create) do |answer, evaluator|
        create(:vote, votable: answer, value: true, user: evaluator.vote_author)
      end
    end
  end

  factory :nil_answer, class: 'Answer' do
    question
    body nil
  end
end
