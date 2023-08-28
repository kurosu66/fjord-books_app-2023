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

  def find_mentioned_reports(report)
    report.content.scan(%r{(?<=reports/)(\d{1,})}).flatten
  end

  def create_mentions(report)
    mentioned_report_ids = find_mentioned_reports(report)
    mentioned_report_ids.each do |mentioned_report_id|
      Mention.create(mentioning_id: report.id, mentioned_id: mentioned_report_id)
    rescue ActiveRecord::RecordNotUnique
      # 更新時、既にMentionに追加済みのReportは無視する
    end
  end

  def update_mentions(before_update_mentions, report)
    after_update_mentions = find_mentioned_reports(report)
    if before_update_mentions.length <= after_update_mentions.length
      report.create_mentions(report)
    else
      deleted_mention_ids = before_update_mentions - after_update_mentions
      report.destroy_mentions(deleted_mention_ids, report)
    end
  end

  def destroy_mentions(deleted_mention_ids, report)
    deleted_mention_ids.each do |deleted_mention_id|
      mention = Mention.find_by(mentioning_id: report.id, mentioned_id: deleted_mention_id)
      mention.destroy!
    end
  end
end
