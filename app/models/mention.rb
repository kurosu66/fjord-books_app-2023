# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioning, class_name: "Report"
  belongs_to :mentioned, class_name: "Report"

  # validates :mentioning_id, uniqueness: { scope: :mentioning_id }
end
