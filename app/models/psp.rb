class Psp < ApplicationRecord
  has_one :psp_mapping, dependent: :destroy
  has_many :payments

  store_accessor :endpoints
  store_accessor :auth
  store_accessor :credentials

  scope :active, -> { where(active: true) }
end
