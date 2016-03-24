require 'features/feature_spec_helpers'

feature 'Sign in with omniauth', '
  In order to authenticate
  As an thirdparty system user
  I want to be able to use my thirdparty account to sign in
' do
  OmniAuth.config.test_mode = true

  describe 'Facebook' do
    before { visit new_user_session_path }

    scenario 'Every user is able to sign in with Facebook' do
      expect(page).to have_link 'Sign in with Facebook'
    end

    describe 'Existing user' do
      given(:user) { create(:user) }
      given(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'facebook',
          uid: '12345',
          info: { email: user.email }
        )
      end

      before { OmniAuth.config.mock_auth[:facebook] = auth }
      after { OmniAuth.config.mock_auth[:facebook] = nil }

      scenario 'without Facebook authorization signs in' do
        click_on 'Sign in with Facebook'

        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end

      scenario 'with authorization signs in' do
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
        click_on 'Sign in with Facebook'

        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end

      scenario 'with different authorization signs in' do
        user.authorizations.create(provider: auth.provider, uid: '11111111')
        click_on 'Sign in with Facebook'
        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end
    end

    describe 'New user' do
      given(:user) { build(:user) }
      given(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'facebook',
          uid: '12345',
          info: { email: user.email }
        )
      end

      before { OmniAuth.config.mock_auth[:facebook] = auth }
      after { OmniAuth.config.mock_auth[:facebook] = nil }

      scenario 'signs in' do
        click_on 'Sign in with Facebook'

        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end
    end
  end

  describe 'Twitter' do
    before { visit new_user_session_path }

    scenario 'Every user is able to sign in with Twitter' do
      expect(page).to have_link 'Sign in with Twitter'
    end

    describe 'Existing user' do
      given(:user) { create(:user) }
      given(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'twitter',
          uid: '12345'
        )
      end

      before { OmniAuth.config.mock_auth[:twitter] = auth }
      after { OmniAuth.config.mock_auth[:twitter] = nil }

      scenario 'with authorization signs in' do
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
        click_on 'Sign in with Twitter'

        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Twitter account'
      end

      describe 'without authorization' do
        scenario 'needs to specify email' do
          click_on 'Sign in with Twitter'

          expect(page).to have_field 'Please enter Your email:'
          expect(page).to have_button 'Proceed'
        end

        scenario 'sends confirmational email' do
          click_on 'Sign in with Twitter'
          fill_in 'Please enter Your email:', with: user.email
          click_on 'Proceed'

          expect(page).to have_content 'Verification email has been sent!'
        end

        scenario 'could sign in after confirming email' do
          clear_emails

          click_on 'Sign in with Twitter'
          fill_in 'Please enter Your email:', with: user.email
          click_on 'Proceed'

          open_email(user.email)
          current_email.click_link 'Confirm my account'

          visit new_user_session_path
          click_on 'Sign in with Twitter'

          expect(current_path).to eq root_path
          expect(page).to have_content 'Successfully authenticated from Twitter account'
        end
      end
    end

    describe 'New user' do
      given(:user) { build(:user) }
      given(:auth) do
        OmniAuth::AuthHash.new(
          provider: 'twitter',
          uid: '12345'
        )
      end

      before { OmniAuth.config.mock_auth[:facebook] = auth }
      after { OmniAuth.config.mock_auth[:facebook] = nil }

      scenario 'sends confirmational email' do
        click_on 'Sign in with Twitter'
        fill_in 'Please enter Your email:', with: user.email
        click_on 'Proceed'

        expect(page).to have_content 'Verification email has been sent!'
      end

      scenario 'could sign in after confirming email' do
        clear_emails

        click_on 'Sign in with Twitter'
        fill_in 'Please enter Your email:', with: user.email
        click_on 'Proceed'

        open_email(user.email)
        current_email.click_link 'Confirm my account'

        visit new_user_session_path
        click_on 'Sign in with Twitter'

        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from Twitter account'
      end
    end
  end
end
