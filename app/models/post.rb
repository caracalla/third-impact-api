class Post < ApplicationRecord
  belongs_to :user

  has_many :comments

  validates :content, presence: true
  validates :title,   presence: true

  validates_presence_of :user
end
