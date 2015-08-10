class CreateForumsPosts < ActiveRecord::Migration
  def change
    create_table :forums_posts, id: false do |t|
      t.belongs_to :forum, index: true
      t.belongs_to :post, index: true
    end
  end
end
