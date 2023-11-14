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

  def find_mentioned_reports
    content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten
  end

  def create_mentions
    ActiveRecord::Base.transaction do
      mentioned_report_ids = find_mentioned_reports
      mentioned_report_ids.each do |mentioned_report_id|
        Mention.create(mentioning_id: id, mentioned_id: mentioned_report_id) unless Mention.exists?(mentioning_id: id, mentioned_id: mentioned_report_id)
      end
    end
  end

  def update_mentions
    active_mentionings.destroy_all
    create_mentions
  end
end
