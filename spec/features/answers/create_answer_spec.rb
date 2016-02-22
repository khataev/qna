require 'features/feature_spec_helpers'

feature 'Question answers', "
  In order to help the author of the question
  As an authenticated user
  I want to answer the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_with_answers) { create(:question_with_answers) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'sees proper count text for question without answers after load' do
      visit question_path(question)

      within '#answers-count' do
        expect(page).to have_content('Currently no answers yet')
      end
      expect(page).to have_content 'Post your answer'
    end

    scenario 'sees proper count text for question with answers after load' do
      visit question_path(question_with_answers)

      cnt = question_with_answers.answers.count
      within '#answers-count' do
        expect(page).to have_content('Answer'.pluralize(cnt))
      end
      expect(page).to have_content 'Post your answer'
    end

    scenario 'answers the question with no answers', js: true do
      answer = build :answer

      visit question_path(question)

      fill_in 'Your answer', with: answer.body
      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content answer.body
      end
      within '#answers-count' do
        expect(page).to have_content('Answer'.pluralize(1))
      end
    end

    scenario 'answers the question with answers', js: true do
      answer = build :answer
      cnt = question_with_answers.answers.count
      visit question_path(question_with_answers)

      fill_in 'Your answer', with: answer.body
      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question_with_answers)
      within '.answers' do
        expect(page).to have_content answer.body
      end
      within '#answers-count' do
        expect(page).to have_content("#{cnt + 1} #{'Answer'.pluralize(cnt + 1)}")
      end
    end

    scenario 'tries to create invalid answer', js: true do
      visit question_path(question)

      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content 'Body is too short (minimum is 10 characters)'
    end
  end
end
