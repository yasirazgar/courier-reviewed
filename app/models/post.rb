class Post < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :comments,
            dependent: :destroy

  validates :title, presence: true
end
