class Like < ActiveRecord::Base
  belongs_to :forum
  belongs_to :person

  belongs_to :likeable, polymorphic: true
end
