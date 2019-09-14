class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  has_one :restaurant, through: :post
  has_many :replies, dependent: :destroy

  validates :body, presence: true
end
