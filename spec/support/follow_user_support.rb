module FollowUserSupport
  def follow_user(user)
    visit user_path(user)
    expect(page).to have_button("アピールする")
    click_on 'アピールする'
    expect(page).to have_button("アピール済")
  end
end