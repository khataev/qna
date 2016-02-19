module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up(user)
    visit new_user_session_path
    click_on 'Register'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
  end

  def check_question_list(questions)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end

  def answer_div(answer_id)
    find("div#answer-#{answer_id}")
  end

  def choose_the_best_answer(question, answer_id = nil)
    unless question.nil?
      answer_ids = question.answers.map(&:id)
      answer_id = answer_ids[rand(0..answer_ids.length - 1)] unless answer_id

      within "div#answer-#{answer_id}" do
        click_on 'Make the Best'
      end

      answer_id
    end
  end

  def choose_another_best_answer(question, old_best_answer_id)
    if question && old_best_answer_id
      new_best_answer_id = question.answers.where.not(id: old_best_answer_id).first.id
      choose_the_best_answer(question, new_best_answer_id)

      new_best_answer_id
    end
  end

  def cancel_the_best_answer
    within '.answers-table' do
      click_on 'Revert'
    end
  end
end
