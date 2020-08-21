記録用（途中で分からなくなりそうだったので）
そのうち消すかも

# DB設計

![share-appのDB設計](https://user-images.githubusercontent.com/62790209/90217191-9efc6800-de3b-11ea-9ad8-650d7e89604b.png)


## usersテーブル
|Column    |Type    |Options|
|----------|--------|-------|
|username  |string  |null: false,unique: true|
|email     |string  |null: false,unique: true|
|password  |string  |null: false|

### Association
- has_many :posts

## postsテーブル
|Column    |Type      |Options|
|----------|----------|-------|
|images    |string    |null: false|
|body      |text      |null: false|
|user_id   |references|foreign_key: true|

### Association
- belongs_to :user
