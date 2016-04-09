FactoryGirl.define do
  sequence :title do |n|
    "Question #{n} Title"
  end

  factory :question do
    title
    sequence(:body) { |n| "Question #{n} Body" }
    author

    transient do
      vote_author :user
      subscriber :user
    end

    factory :question_with_answers do
      after(:create) do |question|
        create_list(:answer, 5, question: question)
      end
    end

    factory :question_with_file do
      after(:create) do |question|
        create(:attachment, attachable: question)
      end
    end

    factory :question_with_file_attached_to_answer do
      after(:create) do |question|
        create(:answer_with_file, question: question, author: question.author)
      end
    end

    factory :question_with_positive_vote do
      after(:create) do |question, evaluator|
        create(:vote, votable: question, value: true, user: evaluator.vote_author)
      end
    end

    factory :question_with_negative_vote do
      after(:create) do |question, evaluator|
        create(:vote, votable: question, value: false, user: evaluator.vote_author)
      end
    end

    factory :question_with_answer_with_positive_vote do
      after(:create) do |question, evaluator|
        create(:answer, question: question)
        create(:vote, votable: question.answers.first, value: true, user: evaluator.vote_author)
      end
    end

    factory :question_with_answer_with_negative_vote do
      after(:create) do |question, evaluator|
        create(:answer, question: question)
        create(:vote, votable: question.answers.first, value: false, user: evaluator.vote_author)
      end
    end

    factory :question_with_subscriber do
      after(:create) do |question, evaluator|
        create(:subscription, question: question, user: evaluator.subscriber)
      end
    end

    factory :question_with_subscribers do
      after(:create) do |question|
        create_list(:subscription, 2, question: question, user: create(:user))
      end
    end
  end

  factory :nil_question, class: 'Question' do
    title nil
    body nil
  end

  factory :question_with_body_less_minimum_size, class: 'Question' do
    title 'Question Title'
    body '123456789'
  end

  factory :question_with_title_more_maximum_size, class: 'Question' do
    title '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901'
    body '1234567890'
  end
end
