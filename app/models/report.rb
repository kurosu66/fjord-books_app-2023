# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentionings, class_name: "Mention", foreign_key: "mentioning_id"
  has_many :mentioning_reports, through: :active_mentionings, source: :mentioned

  has_many :passive_mentionings, class_name: "Mention", foreign_key: "mentioned_id"
  has_many :mentioned_reports, through: :passive_mentionings, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
