require 'features/feature_spec_helpers'

feature 'Subscribe to Question notifications', "
  In order to stay in touch to question's updates
  As an registered user
  I want to subscribe on question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:subscribed_question) { create(:question_with_subscriber, subscriber: user) }

  context 'Non-authenticated user' do
    before { visit question_path(question) }

    scenario "could not subscribe on question's update" do
      within '.subscribe-area' do
        expect(page).to_not have_link 'Subscribe for updates'
      end
    end
  end

  context 'Authenticated user' do
    before do
      sign_in(user)
    end

    context 'subscribe' do
      before do
        visit question_path(question)
      end

      scenario "could subscribe on question's update" do
        within '.subscribe-area' do
          expect(page).to have_link 'Subscribe for updates'
        end
      end

      scenario "could not subscribe twice on question's update" do
        visit question_path(subscribed_question)

        within '.subscribe-area' do
          expect(page).to_not have_link 'Subscribe for updates'
          expect(page).to have_link 'Unsubscribe from updates'
        end
      end

      scenario 'subscribes on', js: true do
        within '.subscribe-area' do
          click_on 'Subscribe for updates'

          within '.subscribe-result' do
            expect(page).to have_content 'Subscription successful'
          end
          expect(page).to_not have_link 'Subscribe for updates'
          expect(page).to have_link 'Unsubscribe from updates'
        end
      end
    end

    context 'unsubscribe' do
      before do
        visit question_path(subscribed_question)
      end

      scenario 'unsubscribes', js: true do
        within '.subscribe-area' do
          click_on 'Unsubscribe from updates'

          within '.subscribe-result' do
            expect(page).to have_content 'Unsubscription successful'
          end
          expect(page).to have_link 'Subscribe for updates'
          expect(page).to_not have_link 'Unsubscribe from updates'
        end
      end
    end
  end
end
