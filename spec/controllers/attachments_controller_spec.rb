require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question2) { create(:question_with_file_attached_to_answer, author: user) }

  describe 'DELETE #destroy question attachment' do
    before { sign_in(user) }

    describe 'by question author' do
      let(:question) { create(:question_with_file, author: user) }

      it 'deletes the attachment' do
        expect { delete :destroy, id: question.attachments.first }.to change(question.attachments, :count).by(-1)
      end
    end

    describe 'by someone else' do
      let(:question) { create(:question_with_file) }

      it 'does not delete the attachment' do
        expect { delete :destroy, id: question.attachments.first }.to_not change(question.attachments, :count)
      end
    end
  end

  describe 'DELETE #destroy answer attachment' do
    describe 'by author' do
      it 'deletes the attachment' do
        sign_in(user)

        expect { delete :destroy, id: question2.answers.first.attachments.first }.to change(question2.answers.first.attachments, :count).by(-1)
      end
    end

    describe 'by someone else' do
      it 'does not delete the attachment' do
        sign_in(another_user)

        expect { delete :destroy, id: question2.answers.first.attachments.first }.to_not change(question2.answers.first.attachments, :count)
      end
    end
  end
end
