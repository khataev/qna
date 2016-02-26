FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} body" }
    author
    question

    factory :answer_with_file do
      after(:create) do |answer|
        create(:attachment, attachmentable: answer)
      end
    end
  end

  factory :nil_answer, class: 'Answer' do
    question
    body nil
  end
end
