class Base < ActiveRecord::Base
  self.abstract_class = true

  #attr_accessor :name

  def to_s
    name
  end
end