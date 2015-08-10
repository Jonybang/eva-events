class Forum < Base
  # name:string alias:string description:string begin_date:datetime end_date:datetime

  belongs_to :organization, class_name: 'Organization'
  belongs_to :creator, class_name: 'Person', foreign_key: 'person_id'

  has_and_belongs_to_many :posts, class_name: 'Post'

  has_and_belongs_to_many :admins, class_name: 'Person', :join_table => 'forums_admins'
  has_and_belongs_to_many :volunteers, class_name: 'Person', :join_table => 'forums_volunteers'
  has_and_belongs_to_many :members, class_name: 'Person', :join_table => 'forums_members'
  has_and_belongs_to_many :visitors, class_name: 'Person', :join_table => 'forums_visitors'
end