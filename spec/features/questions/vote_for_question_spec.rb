require 'features/feature_spec_helpers'

feature 'Vote for question', '
  In order to express sympathy
  As an authenticated user
  I want to vote for question
' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  given(:question_with_positive_vote) { create(:question_with_positive_vote, vote_author: user) }
  given(:question_with_negative_vote) { create(:question_with_negative_vote, vote_author: user) }

  scenario 'Just asked question have zero votes' do
    visit question_path(question)

    within '.vote-counter' do
      expect(page).to have_content('0')
    end
  end

  describe 'Authenticated user' do
    before { sign_in(user) }

    describe 'Votes' do
      before { visit question_path(question) }

      scenario 'can vote for question' do
        expect(page).to have_link('link-vote-for')
      end

      scenario 'can vote against question' do
        expect(page).to have_link('link-vote-against')
      end

      scenario 'votes for question', js: true do
        within '.vote-area' do
          click_on('link-vote-for')

          within '.vote-counter' do
            expect(page).to have_content('1')
          end
          expect(page).to have_link('link-vote-back')
          expect(page).to_not have_link('link-vote-for')
          expect(page).to_not have_link('link-vote-against')
        end
      end

      scenario 'votes against question', js: true do
        within '.vote-area' do
          click_on('link-vote-against')

          within '.vote-counter' do
            expect(page).to have_content('-1')
          end
          expect(page).to have_link('link-vote-back')
          expect(page).to_not have_link('link-vote-for')
          expect(page).to_not have_link('link-vote-against')
        end
      end
    end

    describe 'Cancels previous' do
      before { visit question_path(question_with_positive_vote) }

      scenario 'vote for', js: true do
        click_on('link-vote-back')

        within '.vote-counter' do
          expect(page).to have_content('0')
        end

        within '.vote-area' do
          expect(page).to have_link('link-vote-for')
          expect(page).to have_link('link-vote-against')
          expect(page).to_not have_link('link-vote-back')
        end
      end

      scenario 'vote against', js: true do
        click_on('link-vote-back')

        within '.vote-counter' do
          expect(page).to have_content('0')
        end

        within '.vote-area' do
          expect(page).to have_link('link-vote-for')
          expect(page).to have_link('link-vote-against')
          expect(page).to_not have_link('link-vote-back')
        end
      end
    end
  end

  describe 'Author' do
    before { sign_in(author) }

    scenario 'votes for question', js: true do
      visit question_path(question)

      within '.vote-area' do
        expect(page).to_not have_link('link-vote-for')
      end
    end

    scenario 'votes against question', js: true do
      visit question_path(question)

      within '.vote-area' do
        expect(page).to_not have_link('link-vote-against')
      end
    end
  end

  scenario 'Non-authenticated user cannot vote', js: true do
    visit question_path(question)

    expect(page).to_not have_link('link-vote-for')
    expect(page).to_not have_link('link-vote-against')
    expect(page).to_not have_link('link-vote-back')
  end
end
