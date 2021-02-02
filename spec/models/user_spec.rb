require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    context 'うまくいく場合' do
      it '全ての項目の入力が存在すれば登録できる' do
        expect(@user).to be_valid
      end

      it 'プロフィールが空でも登録できる' do
        @user.profile = nil
        expect(@user).to be_valid
      end

      it 'YouTubeURLが空でも登録できる' do
        @user.youtube = nil
        expect(@user).to be_valid
      end

      it 'プロフィール画像が空でも登録できる' do
        @user.image = nil
        expect(@user).to be_valid
      end
    end
  end
end
