require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
      sleep 1
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

    context 'うまくいくいかない場合' do
      it '名前が空では登録できない' do
        @user.name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("名前を入力してください")
      end

      it 'メールアドレスが空では登録できない' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Eメールを入力してください")
      end

      it 'メールアドレスが一意性であること' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end

      it 'メールアドレスは、@を含む必要があること' do
        @user.email = 'example.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end

      it 'パスワード空では登録できない' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワードを入力してください")
      end

      it 'パスワードは、6文字以上での入力が必須であること（6文字が入力されていれば、登録が可能なこと）' do
        @user.password = 'aaa12'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end

      it 'パスワードは、半角英数字混合での入力が必須であること（半角英数字が混合されていれば、登録が可能なこと）' do
        @user.password = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは英字と数字の両方を含めて半角で設定してください')
      end

      it 'パスワードは、確認用を含めて2回入力すること' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it 'パスワードとパスワード（確認用）は、値の一致が必須であること' do
        @user.password_confirmation = 'abc123'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
      end

      it 'パスワードは、全角では登録できないこと' do
        @user.password = 'ＡＢＣ123'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは英字と数字の両方を含めて半角で設定してください')
      end

      it 'パスワードは、数字のみでは登録できないこと' do
        @user.password = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは英字と数字の両方を含めて半角で設定してください')
      end

      it '活動地域が空では登録できない' do
        @user.area_id = 1
        @user.valid?
        expect(@user.errors.full_messages).to include("活動地域は1以外の値にしてください")
      end

      it '属性が空では登録できない' do
        @user.profession_id = 1
        @user.valid?
        expect(@user.errors.full_messages).to include("属性は1以外の値にしてください")
      end
    end
  end

  describe '検証' do
    before do
      @user = FactoryBot.create(:user)
      @another_user = FactoryBot.create(:user)
      sleep 1
    end

    context 'パスワードの検証' do
      it 'パスワードが暗号化されていること' do
        @user.password = 'aaa111'
        expect(@user.encrypted_password).to_not eq @user.password
      end
    end

    context 'フォローの検証' do
      it'ユーザーが他のユーザーをフォロー、フォロー解除可能である' do
        @user.follow(@another_user)
        expect(@user.following?(@another_user)).to eq true
        @user.unfollow(@another_user)
        expect(@user.following?(@another_user)).to eq false
      end
    
      it 'フォロー中のユーザーが削除されると、フォローが解消される' do
        @user.follow(@another_user)
        expect(@user.following?(@another_user)).to eq true
        @user.destroy
        expect(@user.following?(@another_user)).to eq false
      end
    end
  end
end
