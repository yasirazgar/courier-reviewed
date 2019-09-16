# Column      |              Type              | Collation | Nullable |              Default
# -----------------+--------------------------------+-----------+----------+-----------------------------------
#  id              | bigint                         |           | not null | nextval('users_id_seq'::regclass)
#  username        | character varying              |           |          |
#  email           | character varying              |           |          |
#  password_digest | character varying              |           |          |
#  created_at      | timestamp(6) without time zone |           | not null |
#  updated_at      | timestamp(6) without time zone |           | not null |
#  Indexes:
#     "users_pkey" PRIMARY KEY, btree (id)

class User < ApplicationRecord
  has_secure_password

  has_many :created_restaurants, -> {
              order(posts_count: :desc)
            },
            class_name: 'Restaurant',
            inverse_of: :creator

  has_and_belongs_to_many :joined_restaurants, -> {
                            order(posts_count: :desc)
                          },
                          class_name: 'Restaurant',
                          join_table: 'restaurants_users'

  has_many :posts, -> { order(comments_count: :desc) }
  has_many :comments
  has_many :replies

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true

  # TODO: Improvement, Add starts/ratings to posts and order restaurants by stars/ratings counts
  def restaurants
    Restaurant
      .where(id: joined_restaurants.select(:id))
      .or(Restaurant.where(user_id: id))
      .order('posts_count DESC')
  end
end
