require 'rails_helper'

RSpec.describe "マッチング", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    sleep 0.5
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

RSpec.describe "メッセージ", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    sleep 0.5
  end

  context 'マッチングしたとき' do
    it 'メッセージページにアクセスできる' do
      #マッチング
      sign_in(@another_user)
      follow_user(@user)
      click_on 'ログアウト'
      sign_in(@user)
      follow_user(@another_user)
      #マッチング一覧ページにアクセスする
      visit matching_index_path(@user)
      #マッチしたユーザーの名前をクリックする
      click_on "#{@another_user.name}"
      #チャットルームに遷移する(状況に応じてルーム番号を変更する)
      expect(current_path).to eq ("/chat_rooms/1")
    end

    it 'メッセージを送ることができる' do
      sign_in(@another_user)
      follow_user(@user)
      click_on 'ログアウト'
      sign_in(@user)
      follow_user(@another_user)
      #マッチング一覧ページにアクセスする
      visit matching_index_path(@user)
      #チャットルームに遷移する
      click_on "#{@another_user.name}"
      #メッセージを入力
      find(".chat-room__message-form_textarea").set("Hello!")
      #Enterキーを押すとメッセージが送信される
      find(".chat-room__message-form_textarea").send_keys(:enter)
      #送信したメッセージが表示されている
      expect(page).to have_content("Hello!")
    end

    it '送られたメッセージを見ることができる' do
      sign_in(@user)
      follow_user(@another_user)
      click_on 'ログアウト'
      sign_in(@another_user)
      follow_user(@user)
      visit matching_index_path(@another_user)
      click_on "#{@user.name}"
      #相手がメッセージを送る
      find(".chat-room__message-form_textarea").set("Hello!")
      find(".chat-room__message-form_textarea").send_keys(:enter)
      expect(page).to have_content("Hello!")
      click_on 'ログアウト'
      sign_in(@user)
      visit matching_index_path(@user)
      click_on "#{@another_user.name}"
      #相手のメッセージを確認する
      expect(page).to have_content("Hello!")
    end
  end
end