# id          | bigint                         |           | not null | nextval('restaurants_id_seq'::regclass)
#  user_id     | bigint                         |           | not null |
#  name        | character varying              |           |          |
#  posts_count | character varying              |           |          |
#  created_at  | timestamp(6) without time zone |           | not null |
#  updated_at  | timestamp(6) without time zone |           | not null |
# Indexes:
#     "restaurants_pkey" PRIMARY KEY, btree (id)
#     "index_restaurants_on_user_id" btree (user_id)

class Restaurant < ApplicationRecord
  belongs_to :creator,
              class_name: 'User',
              foreign_key: 'user_id'
  has_and_belongs_to_many :couriers,
                          class_name: 'User',
                          join_table: 'ResturantCouriers'
  has_many :posts

  validates :name, presence: true
end
