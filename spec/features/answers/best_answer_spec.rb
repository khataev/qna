require 'features/feature_spec_helpers'

feature 'Best answer', '
  As an author of question
  I want to be able to choose the best answer
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_answers, author: user) }
  given!(:other_user_question) { create(:question) }

  scenario 'Non-authenticated user' do
    visit question_path(question)

    expect(page).to_not have_link 'The Best Answer'
  end

  describe 'Authenticated user' do
    scenario 'could not choose The Best answer of another user question' do
      sign_in(user)
      visit question_path(other_user_question)

      expect(page).to_not have_link 'The Best Answer'
    end
  end

  describe 'Author of question' do
    before do
      sign_in(user)
      # binding.pry
      visit question_path(question)
      # binding.pry
    end

    scenario 'sees as many links to make best answer as numbers of questions initially' do
      question.answers.each do |answer|
        within "div#answer-#{answer.id}" do
          expect(page).to have_link 'Make the Best'
        end
      end
    end

    describe 'chooses the best answer' do
      before do
        @best_answer_id = choose_the_best_answer(question)
        sleep(1)
      end

      scenario 'and stays on the same page', js: true do
        expect(current_path).to eq question_path(question)
      end

      scenario 'sees the chosen answer as the best', js: true do
        expect(answer_div(@best_answer_id)[:class]).to eq 'best-answer'
      end

      scenario 'sees appropriate link', js: true do
        expect(answer_div(@best_answer_id)).to have_link('Revert')
        expect(answer_div(@best_answer_id)).to_not have_link('Make the Best')
      end

      scenario 'and cancels it', js: true do
        # binding.pry
        cancel_the_best_answer

        within '.answers-table' do
          expect(page).to_not have_selector('.best_answer')
        end
      end

      scenario 'and reassigns the best to another answer', js: true do
        new_best_answer_id = choose_another_best_answer(question, @best_answer_id)
        sleep(1) # intentional delay
        # expect(answer_div(@best_answer_id)).to_not have_selector('.best-answer')
        # expect(answer_div(new_best_answer_id)).to have_selector('.best-answer')
        expect(answer_div(@best_answer_id)[:class]).to_not eq 'best-answer'
        expect(answer_div(new_best_answer_id)[:class]).to eq 'best-answer'
      end
    end
  end
end
