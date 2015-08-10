class Person < User
  # fullname:string registered_on:datetime registered_from:integer


  belongs_to :invited_by, class_name: 'Person', inverse_of: :invited, foreign_key: 'person_id'

  has_many :invited, class_name: 'Person', inverse_of: :invited_by
  has_many :creator_forums, class_name: 'Forum', inverse_of: :creator
  has_many :creator_organizations, class_name: 'Organization', inverse_of: :creator
  has_many :posts, class_name: 'Post', inverse_of: :posted_by

  has_and_belongs_to_many :organizations, class_name: 'Organization', inverse_of: :team, :join_table => 'organizations_teams'

  has_and_belongs_to_many :admin_forums, class_name: 'Forum', inverse_of: :admins, :join_table => 'forums_admins'
  has_and_belongs_to_many :volunteer_forums, class_name: 'Forum', inverse_of: :volunteers, :join_table => 'forums_volunteers'
  has_and_belongs_to_many :member_forums, class_name: 'Forum', inverse_of: :members, :join_table => 'forums_members'
  has_and_belongs_to_many :visitor_forums, class_name: 'Forum', inverse_of: :visitors, :join_table => 'forums_visitors'

  has_and_belongs_to_many :admin_events, class_name: 'Event', inverse_of: :admins, :join_table => 'events_admins'
  has_and_belongs_to_many :volunteer_events, class_name: 'Event', inverse_of: :volunteers, :join_table => 'events_volunteers'
  has_and_belongs_to_many :member_events, class_name: 'Event', inverse_of: :members, :join_table => 'events_members'
  has_and_belongs_to_many :visitor_events, class_name: 'Event', inverse_of: :visitors, :join_table => 'events_visitors'
end