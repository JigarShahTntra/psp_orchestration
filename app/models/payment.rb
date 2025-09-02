class Payment < ApplicationRecord
  belongs_to :psp, optional: true

  enum :status, {
    pending: "pending",
    authorized: "authorized",
    declined: "declined",
    captured: "captured",
    settled: "settled"
  }, prefix: true
end
