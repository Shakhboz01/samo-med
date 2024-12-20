class Room < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :room_members
end
