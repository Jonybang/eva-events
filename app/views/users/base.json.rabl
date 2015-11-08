attribute :id, :name, :email

node :image do |obj|
    obj.image ? obj.image :
end