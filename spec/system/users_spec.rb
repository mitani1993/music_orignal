require 'rails_helper'

RSpec.describe "新規登録", type: :system do
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

RSpec.describe "ログイン", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    sleep 1
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(user_path(@user))
      # ログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end

    context 'ログインができないとき' do
      it '保存されているユーザーの情報と合致せずログインができない' do
        # トップページに移動する
        visit root_path
        # トップページにログインページへ遷移するボタンがあることを確認する
        expect(page).to have_content('ログイン')
        # ログインページへ遷移する
        visit new_user_session_path
        # 正しいユーザー情報を入力する
        fill_in 'user[email]', with: ""
        fill_in 'user[password]', with: ""
        # ログインボタンを押す
        find('input[name="commit"]').click
        # ページが遷移しないことを確認する
        expect(current_path).to eq(new_user_session_path)
      end
    end

    context 'ログインしていないとき' do
      it 'ユーザー一覧ページにアクセスしたときサインページに遷移する' do
        #ユーザー一覧にアクセス
        visit users_path
        #サインインページに遷移する
        expect(current_path).to eq(new_user_session_path)
      end

      it 'ユーザー詳細ページにアクセスしたときサインページに遷移する' do
        #ユーザー詳細ページ
        visit user_path(@user)
        #サインインページに遷移する
        expect(current_path).to eq(new_user_session_path)
      end
    end

    context 'ログインしているとき' do
      it 'ログインするとマイページに遷移する'do
        #サインインする
        sign_in(@user)
        #マイページに名前、活動地域、属性が表示されている
        expect(page).to have_content(@user.name)
        expect(page).to have_content(@user.area.name)
        expect(page).to have_content(@user.profession.name)
        #アプローチ一覧ボタンがある
        expect(page).to have_content("アプローチ一覧")
        #アピール一覧ボタンがある
        expect(page).to have_content("アピール一覧")
        #編集ボタンがある
        expect(page).to have_content("編集")
        #アピールボタンがない
        expect(page).to have_no_content("アピールする")
      end

      it '他のユーザーページを閲覧する'do
        #サインインする
        sign_in(@user)
        #他のユーザーページにアクセスする
        visit user_path(@another_user)
        #名前、活動地域、属性が表示されている
        expect(page).to have_content(@another_user.name)
        expect(page).to have_content(@another_user.area.name)
        expect(page).to have_content(@another_user.profession.name)
        #アプローチ一覧ボタンがない
        expect(page).to have_no_content("アプローチ一覧")
        #アピール一覧ボタンがない
        expect(page).to have_no_content("アピール一覧")
        #編集ボタンがない
        expect(page).to have_no_content("編集")
        #アピールボタンがある
        expect(page).to have_button("アピールする")
      end

      it '他のユーザーにアピールを送る'do
        #サインインする
        sign_in(@user)
        #他のユーザーページにアクセスする
        visit user_path(@another_user)
        #アピールボタンがある
        expect(page).to have_button("アピールする")
        #アピールボタンを押す
        click_on 'アピールする'
        #アピールボタンがアピール済に変わる
        expect(page).to have_button("アピール済")
      end

      it '他のユーザーのアピールを外す'do
        #サインインする
        sign_in(@user)
        #他のユーザーページにアクセスする
        visit user_path(@another_user)
        #アピールボタンがある
        expect(page).to have_button("アピールする")
        #アピールボタンを押す
        click_on 'アピールする'
        #アピールボタンがアピール済に変わる
        expect(page).to have_button("アピール済")
        #アピールを外す
        click_on 'アピール済'
        #アピール済がアピールするに変わる
        expect(page).to have_button("アピールする")
      end
    end
  end
end

RSpec.describe "アピール、アプローチ一覧表示", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    sleep 1
  end

  context 'アプローチ一覧' do 
    it '他のユーザーにアピールを受けたとき、一覧に表示される' do
      #他のサインインする
      sign_in(@another_user)
      #他のユーザーが自分にアプローチする
      follow_user(@user)
      click_on 'ログアウト'
      #サインインする
      sign_in(@user)
      #アプローチ一覧ページにアクセスする
      visit follower_user_path(@user)
      #アプローチしたユーザーの名前が表示されている
      expect(page).to have_content(@another_user.name)
    end
    
    it '他のユーザーがアピールしなければ一覧に表示されない' do
      #サインイン
      sign_in(@user)
      #アプローチ一覧ページにアクセスする
      visit follower_user_path(@user)
      #アプローチ一覧に何も表示されていない
      expect(page).to have_no_content(@another_user.name)
    end
  end
  
  context 'アピール一覧' do
    it '他のユーザーにアピールすると、アピール一覧に表示される' do
      #サインイン
      sign_in(@user)
      #他のユーザーにアピールする
      follow_user(@another_user)
      #アピール一覧ページにアクセスする
      visit followed_user_path(@user)
      #アピールしたユーザーの名前が表示されている
      expect(page).to have_content(@another_user.name)
    end

    it '他のユーザーにアピールしなければ、アピール一覧に表示されない' do
      #サインイン
      sign_in(@user)
      #アピール一覧ページにアクセスする
      visit followed_user_path(@user)
      #アピール一覧に何も表示されていない
      expect(page).to have_no_content(@another_user.name)
    end
  end

  context 'アクセスできないとき' do
    it '他のユーザーのアプローチ一覧にはアクセスできない' do
      #サインイン
      sign_in(@user)
      #他のユーザーのアプローチ一覧ページにアクセスする
      visit follower_user_path(@another_user)
      #マイページに遷移する
      expect(current_path).to eq(user_path(@user))
    end

    it '他のユーザーのアピール一覧にはアクセスできない' do
      #サインイン
      sign_in(@user)
      #他のユーザーのアピール一覧ページにアクセスする
      visit followed_user_path(@another_user)
      #マイページに遷移する
      expect(current_path).to eq(user_path(@user))
    end
  end
end