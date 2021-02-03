require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user)
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
end
