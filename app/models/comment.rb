class Comment < ActiveRecord::Base

  validates :content, :author_id, :post_id, presence: true

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
    )

  belongs_to :post

  has_many(
    :child_comments,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    primary_key: :id
    )
end
