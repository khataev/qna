require_relative 'concerns/votable_spec'

RSpec.describe Answer, type: :model do
  # associations
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  # validations
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_length_of(:body).is_at_least(10) }

  # nested attributes
  it { should accept_nested_attributes_for :attachments }

  describe 'make the best' do
    let(:question) { create(:question_with_answers) }

    before do
      @best_answer = question.answers.last
      @best_answer.make_the_best
    end

    it 'sets the best answer' do
      expect(@best_answer).to be_best
      expect(Answer.where(question_id: question.id, best: true).count).to eq 1
    end

    it 'orders best answer before other answers' do
      question.reload

      expect(question.answers.first).to eq @best_answer
    end

    it 'cancels setting answer as the best' do
      @best_answer.make_the_best

      expect(@best_answer).to_not be_best
      expect(Answer.where(question_id: question.id, best: true).count).to eq 0
    end

    it 'reassigns the best status to another question' do
      question.reload
      @new_best_answer = question.answers.last
      @new_best_answer.make_the_best
      question.reload

      expect(Answer.find(@new_best_answer.id)).to be_best
      expect(Answer.find(@best_answer.id)).to_not be_best
      expect(Answer.where(question_id: question.id, best: true).count).to eq 1
    end
  end

  # Votable interface
  it_behaves_like 'votable'
end
