FactoryGirl.define do
  sequence :file do |n|
    "File #{n}"
  end

  factory :attachment do
    file
    after :create do |b|
      b.update_column(:file, "#{Rails.root}/spec/rails_helper.rb")
    end
  end
end
