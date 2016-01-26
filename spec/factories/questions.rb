FactoryGirl.define do
  factory :question do
    title 'Question Title'
    body 'Question Body'
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
