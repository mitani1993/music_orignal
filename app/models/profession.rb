class Profession < ActiveHash::Base
  self.data = [
    { id: 1, name: '--' },
    { id: 2, name: 'バンド・ユニット' },
    { id: 3, name: 'シンガーソングライター' },
    { id: 4, name: 'DJ・ラッパー' },
    { id: 5, name: 'ライブハウス・クラブ' },
  ]
end