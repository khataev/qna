FactoryGirl.define do
  factory :answer do
    question
    body 'Answer Body'
  end

  factory :nil_answer, class: 'Answer' do
    question
    body nil
  end
end
