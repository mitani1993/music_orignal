require 'rails_helper'

RSpec.describe "マッチング", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
  end

  context 'フォローされているとき' do 
    it '他のユーザーをフォローしたときに一覧に表示される' do
      #他のサインインする
      sign_in(@another_user)
      #他のユーザーが自分をフォローする
      follow_user(@user)
      click_on 'ログアウト'
      #サインインする
      sign_in(@user)
      #自分も他のユーザーをフォローする
      follow_user(@another_user)
      #マッチング一覧ページにアクセスする
      visit matching_index_path(@user)
      #マッチしたユーザーの名前が表示されている
      expect(page).to have_content(@another_user.name)
    end

    it '他のユーザーをフォローしなければ一覧に表示されない' do
      sign_in(@another_user)
      follow_user(@user)
      click_on 'ログアウト'
      #サインインする
      sign_in(@user)
      #マッチング一覧ページにアクセスする
      visit matching_index_path(@user)
      #マッチング一覧に何も表示されていない
      expect(page).to have_no_content(@another_user.name)
    end
  end

  context 'フォローされていないとき' do
    it '自分がフォローしていてもマッチング一覧に表示されない' do
      #サインイン、フォロー
      sign_in(@user)
      follow_user(@another_user)
      #マッチング一覧ページにアクセスする
      visit matching_index_path(@user)
      #マッチング一覧に何も表示されていない
      expect(page).to have_no_content(@another_user.name)
    end
  end
end