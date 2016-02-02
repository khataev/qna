require 'rails_helper'

RSpec.describe User, type: :model do
  # associations
  it { should have_many(:questions) }

  # validations
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
