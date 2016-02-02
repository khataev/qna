FactoryGirl.define do
  factory :answer do
    body 'Answer Body'
    author
    question
  end

  factory :nil_answer, class: 'Answer' do
    question
    body nil
  end
end
