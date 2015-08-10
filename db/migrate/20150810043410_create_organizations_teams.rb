class CreateOrganizationsTeams < ActiveRecord::Migration
  def change
    create_table :organizations_teams, id: false do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :person, index: true
    end
  end
end
