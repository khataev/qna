require 'rails_helper'

RSpec.describe Vote, type: :model do
  # associations
  it { should belong_to(:user) }
  it { should belong_to(:votable) }
end
