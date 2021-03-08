# アプリ名
### **Music Connect**
![top](https://user-images.githubusercontent.com/69582233/108025311-9a726f80-7069-11eb-86fb-20113c3c4613.jpg)

# 概要
ミュージシャン、バンドマンやライブハウスなど音楽に携わる人を支援するマッチングサービス。

# URL
http://www.music-connect.jp/

ログイン情報（テスト用） 
- Eメール: hoge@hoge.com
- password: aaa111

# 制作背景（意図）
　趣味である音楽活動を通じて感じた課題を解消すべくこのアプリケーションを制作した。

### 現状 <br>
- 音楽活動をしている人がライブに出演したい場合、ホームページから直接アプローチをかける、もしくはTwitter等のSNSでダイレクトメッセージを送る
- ライブハウス等の事業者側も出演者を募るためTwitter等のSNSでアプローチをかける

### 課題、問題点 <br>
- ライブに出演したくないアーティスト側にライブハウス側からオファーがくる
- 出演者を募っていないライブハウス側にアーティスト側からメッセージが来る

### 解決策
- Twitterの様な幅広いアプリではなく**音楽をする人向けに特化した需要と供給をマッチさせる**マッチングサービスの制作

### 工夫した点
- ユーザー視点に立ち直感的に操作しやすいように必要最小限の機能に抑えた点<br>
<br>
例えば、音源アップロード機能を実装しようと考えたが、ファイル形式やサイズ、アップロードにかかる時間を考えればYouTubeのURLを貼り付けたほうがアップロードもしやすく、他のユーザも視聴しやすいと思いYouTubeの埋め込みを作成した。

### 苦労した点
- 非同期でのフォロー機能の実装<br>
Qiita等の記事を参考にしながら、トライアンドエラーを繰り返し実装

- チャット機能の実装(ActionCable)
- binding.pryとdebuggerでデータの流れを追いながら少しずつ実装


# 機能一覧
- ユーザー登録・編集（gem devise, active hash）
- ログイン、ログアウト機能(gem devise)
- SNS認証 Google,Facebook(gem omniauth)
![devise](https://user-images.githubusercontent.com/69582233/108025434-d1488580-7069-11eb-8306-c0c01e1feea6.jpg)
- プロフィール画像の登録（ActiveStorage）
- ユーザー一覧機能
- フォロー機能(非同期)
- マッチング機能
![match](https://user-images.githubusercontent.com/69582233/108951453-5c013400-76ab-11eb-9627-245dee5c6a3b.gif)
- メッセージ機能(ActionCable)
![messe](https://user-images.githubusercontent.com/69582233/108951507-75a27b80-76ab-11eb-83e2-80328b8bb036.gif)
- ユーザー検索機能(gem ransack)
![検索](https://user-images.githubusercontent.com/69582233/108951411-45f37380-76ab-11eb-9f98-c6257e180616.gif)


# 使用技術
## フロントエンド
- HTML
- CSS(SCSS)
- Bootstrap4
- Javascript

## バックエンド
- Ruby2.6.5
- Ruby on Rails 6.0.3.4

## データベース
- MySQL2 MariaDB

## テスト
- RSpec(SystemSpec)
- FactoryBot
- Faker

## 本番環境
- AWS(EC2, S3, Route53)
- Nginx
- Unicorn
- Capistrano

## ソース管理
- GitHub, GitHubDesktop
<br>

# DB設計

## usersテーブル

| Column             | Type      | Options     
| ----------         | ------    | ----------- 
| name               | string    | null: false
| email              | string    | null: false, unique: true
| encrypted_password | string    | null: false
| profile            | text      |
| youtube            | string    |
| area_id            | integer   | null: false
| profession_id      | integer   | null: false

### Association
- has_many :sns_credentials
- has_many :room_users
- has_many :chat_rooms, through: :room_users
- has_many :messages
- has_many :relationships,foreign_key: "user_id", dependent: :destroy
- has_many :followings, through: :relationships, source: :follow
- has_many :passive_relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
- has_many :followers, through: :passive_relationships, source: :user
- has_one_attached :image

## relationshipsテーブル
| Column           | Type      | Options     
| ----------       | ------    | ----------- 
| user             | reference | foreign_key: true
| follow           | reference | foreign_key: {to_table: :users}

### Association
- belongs_to :user
- belongs_to :follow, class_name: "User"

## chat_roomsテーブル
| Column        | Type      | Options     
| -------       | ------    | ----------- 

### Association
- has_many :room_users
- has_many :users, through: :room_users
- has_many :messages


## room_usersテーブル
| Column        | Type      | Options     
| -------       | ------    | ----------- 
| chat_room     | reference | foreign_key: true
| user          | reference | foreign_key: true

### Association
- belongs_to :user
- belongs_to :chat_room


## messagesテーブル
| Column        | Type      | Options     
| -------       | ------    | ----------- 
| message       | text      | null: false
| user          | reference | foreign_key: true
| chat_room     | reference | foreign_key: true

### Association
- belongs_to :user
- belongs_to :chat_room

## sns_credentialsテーブル
| Column        | Type      | Options     
| -------       | ------    | ----------- 
| provider      | string    |  
| uid           | string    |  
| user          | reference | foreign_key: true

### Association
- belongs_to :user

# ER図
![alt](ER.png)