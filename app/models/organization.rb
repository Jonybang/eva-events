class Organization < Base
  # name:string

  belongs_to :creator, class_name: 'Person', foreign_key: 'person_id'

  has_many :forums, class_name: 'Forum'

  has_and_belongs_to_many :team, class_name: 'Person', inverse_of: :organizations, :join_table => 'organizations_teams'
end