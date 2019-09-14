class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment, counter_cache: true
  has_one :restaurant, through: :comment

  validates :body, presence: true
end
