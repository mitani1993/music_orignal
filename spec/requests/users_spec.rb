require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    sleep 0.5
  end

  describe "GET #index" do
    context 'ログインしているとき' do
      it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
        sign_in @user
        get users_path
        expect(response.status).to eq 200
      end
    end

    context 'ログインしていないとき' do
      it 'indexアクションにリクエストするとログイン画面に遷移する' do
        get users_path
        expect(response.status).to eq 302
      end
    end
  end

  describe "GET #show" do
    context 'ログインしているとき' do
      it 'マイページにリクエストすると正常にレスポンスが返ってくる' do
        sign_in @user
        get user_path(@user)
        expect(response.status).to eq 200
      end

      it 'マイページにリクエストすると自分の名前が表示される' do
        sign_in @user
        get user_path(@user)
        expect(response.body).to include(@user.name)
      end

      it 'マイページにリクエストすると自分の属性が表示される' do
        sign_in @user
        get user_path(@user)
        expect(response.body).to include(@user.profession.name)
      end

      it 'マイページにリクエストすると自分の活動地域が表示される' do
        sign_in @user
        get user_path(@user)
        expect(response.body).to include(@user.area.name)
      end

      it '他のユーザーページにリクエストすると正常にレスポンスが返ってくる' do
        sign_in @user
        get user_path(@another_user)
        expect(response.status).to eq 200
      end

      it '他のユーザーがマイページにリクエストすると正常にレスポンスが返ってくる' do
        sign_in @another_user
        get user_path(@user)
        expect(response.status).to eq 200
      end

      it '他のユーザーがマイページにリクエストするとアピールボタンがある' do
        sign_in @another_user
        get user_path(@user)
        expect(response.body).to include("アピールする")
      end
    end

    context 'ログインしていないとき' do
      it 'マイページにリクエストするとログイン画面に遷移する' do
        get users_path
        expect(response.status).to eq 302
      end

      it '他のユーザーページにリクエストするとログイン画面に遷移する' do
        get user_path(@another_user)
        expect(response.status).to eq 302
      end
    end
  end
end
