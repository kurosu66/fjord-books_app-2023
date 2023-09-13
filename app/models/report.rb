# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentionings, class_name: 'Mention', foreign_key: 'mentioning_id', dependent: :destroy, inverse_of: :mentioning
  has_many :mentioning_reports, through: :active_mentionings, source: :mentioned, dependent: :destroy

  has_many :passive_mentionings, class_name: 'Mention', foreign_key: 'mentioned_id', dependent: :destroy, inverse_of: :mentioned
  has_many :mentioned_reports, through: :passive_mentionings, source: :mentioning, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
