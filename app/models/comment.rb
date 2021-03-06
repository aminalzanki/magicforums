class Comment < ApplicationRecord
  has_many :votes
  belongs_to :post
  belongs_to :user
  mount_uploader :image, ImageUploader

  def total_votes_num
    votes.pluck(:value).sum
  end
end
