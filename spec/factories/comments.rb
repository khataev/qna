FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment #{n} Body" }
    author
  end

  factory :comment_with_nil_body, class: 'Comment' do
    body nil
    author
  end
end
