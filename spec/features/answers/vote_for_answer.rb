require 'features/feature_spec_helpers'

feature 'Vote for answer', '
  In order to express sympathy
  As an authenticated user
  I want to vote for answer
' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: author, question: question) }

  given(:question_with_answer_with_positive_vote) { create(:question_with_answer_with_positive_vote, vote_author: user) }
  # given(:question_with_answer_with_negative_vote) { create(:question_with_answer_with_negative_votee, vote_author: user) }

  scenario 'Just created answer have zero votes' do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      within '.vote-counter' do
        expect(page).to have_content('0')
      end
    end
  end

  describe 'Authenticated user' do
    before { sign_in(user) }

    describe 'Votes' do
      before { visit question_path(question) }

      scenario 'can vote for answer' do
        within "#answer-#{answer.id}" do
          expect(page).to have_link('link-vote-for')
        end
      end

      scenario 'can vote against answer' do
        within "#answer-#{answer.id}" do
          expect(page).to have_link('link-vote-against')
        end
      end

      scenario 'votes for answer', js: true do
        within "#answer-#{answer.id}" do
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
      end

      scenario 'votes against answer', js: true do
        within "#answer-#{answer.id}" do
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
    end

    describe 'Cancels previous' do
      before { visit question_path(question_with_answer_with_positive_vote) }

      scenario 'vote for', js: true do
        answer = question_with_answer_with_positive_vote.answers.first

        within "#answer-#{answer.id}" do
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

      scenario 'vote against', js: true do
        answer = question_with_answer_with_positive_vote.answers.first

        within "#answer-#{answer.id}" do
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
  end

  describe 'Author' do
    before { sign_in(author) }

    scenario 'votes for answer', js: true do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        within '.vote-area' do
          click_on('link-vote-for')

          within '.vote-counter' do
            expect(page).to have_content('0')
          end

          within '.vote-errors' do
            expect(page).to have_content("You can't vote for your answer")
          end
        end
      end
    end

    scenario 'votes against answer', js: true do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        within '.vote-area' do
          click_on('link-vote-against')

          within '.vote-counter' do
            expect(page).to have_content('0')
          end

          within '.vote-errors' do
            expect(page).to have_content("You can't vote for your answer")
          end
        end
      end
    end
  end

  scenario 'Non-authenticated user cannot vote' do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to_not have_link('link-vote-for')
      expect(page).to_not have_link('link-vote-against')
      expect(page).to_not have_link('link-vote-back')
    end
  end
end
