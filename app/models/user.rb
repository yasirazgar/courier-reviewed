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

  has_many :created_restaurants,
            class_name: 'Restaurant',
            inverse_of: :creator
  has_and_belongs_to_many :restaurants,
                          join_table: 'ResturantCouriers'
  has_many :posts
  has_many :comments
  has_many :replies

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
end
