object @user
attributes :id, :email

child :contact do
  attributes :id, :name
  child :project_tasks do
    attributes :id, :name
  end
  child :skills do
    attributes :id, :name
  end
  child :team_projects do
    attributes :id, :name
  end
end