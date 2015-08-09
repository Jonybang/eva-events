object @contact
attributes :id, :name, :created_at, :updated_at
glue(:contact_data) {|contact| attribute :email }