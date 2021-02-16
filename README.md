# アプリ名
### **Music Connect**
<br>

# URL
http://www.music-connect.jp/
<br>

ログイン情報（テスト用）
- Eメール: hoge@hoge.com
- password: aaa111
<br>

# 制作背景（意図）

<br>

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
- MySQL2

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
