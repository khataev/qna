FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }
    author
    question
  end

  factory :nil_answer, class: 'Answer' do
    question
    body nil
  end
end
