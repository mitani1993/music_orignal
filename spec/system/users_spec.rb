require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do 
    it '正しい情報を入力すればユーザー新規登録ができてユーザー一覧ページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('アカウントを作成する')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[email]', with: @user.email
      fill_in 'user[name]', with: @user.name
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      select '北海道', from: 'user[area_id]'
      select 'バンド・ユニット', from: 'user[profession_id]'
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # ユーザー一覧へ遷移する
      expect(current_path).to eq(users_path)
      # ログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('アカウントを作成する')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do 
    it '誤った情報ではユーザー新規登録ができずページが遷移しない' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('アカウントを作成する')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[email]', with: ""
      fill_in 'user[name]', with: ""
      fill_in 'user[password]', with: ""
      fill_in 'user[password_confirmation]', with: ""
      # サインアップボタンを押すとユーザーモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # ページ遷移が起きない
      expect(current_path).to eq('/users')
    end
  end
  
end
