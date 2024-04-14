class PackUsage < ApplicationRecord
  belongs_to :pack, class_name: 'Pack'
  belongs_to :list_of_pack, class_name: 'Pack', foreign_key: 'list_of_pack_id'
  validates_presence_of :amount
  validates :list_of_pack, presence: true, uniqueness: { scope: :pack_id }
end
