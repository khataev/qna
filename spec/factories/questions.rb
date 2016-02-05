FactoryGirl.define do
  sequence :title do |n|
    "Question #{n} Title"
  end

  sequence :body do |n|
    "Question #{n} Body"
  end

  factory :question do
    title
    body
    author

    factory :question_with_answers do
      after(:create) do |question|
        create_list(:answer, 2, question: question)
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
