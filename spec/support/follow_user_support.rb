module FollowUserSupport
  def follow_user(user)
    visit user_path(user)
    expect(page).to have_button("アピールする")
    click_on 'アピールする'
    expect(page).to have_button("アピール済")
    click_on 'ログアウト'
  end
end