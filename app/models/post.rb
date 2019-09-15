# id             | bigint                         |           | not null | nextval('posts_id_seq'::regclass)
#  user_id        | bigint                         |           | not null |
#  restaurant_id  | bigint                         |           | not null |
#  title          | character varying              |           |          |
#  description    | text                           |           |          |
#  comments_count | integer                        |           |          |
#  created_at     | timestamp(6) without time zone |           | not null |
#  updated_at     | timestamp(6) without time zone |           | not null |
# Indexes:
#     "posts_pkey" PRIMARY KEY, btree (id)
#     "index_posts_on_restaurant_id" btree (restaurant_id)
#     "index_posts_on_user_id" btree (user_id)

class Post < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :comments, dependent: :destroy

  validates :title, presence: true
end
