class Attribute < ActiveRecord::Base
  belongs_to :entity
  has_many :attribute_measures
end
