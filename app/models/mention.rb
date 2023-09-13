# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report'
  belongs_to :mentioned, class_name: 'Report'

  validates :id, uniqueness: {
    scope: %i[mentioning_id mentioned_id]
  }

  def self.create_mentions(report)
    mentioned_report_ids = find_mentioned_reports(report)
    mentioned_report_ids.each do |mentioned_report_id|
      create(mentioning_id: report.id, mentioned_id: mentioned_report_id)
    end
  end

  def self.find_mentioned_reports(report)
    report.content.scan(%r{(?<=reports/)(\d{1,})}).flatten
  end

  def self.update_mentions(report)
    existing_mentions = Mention.all.map { |mention| [mention.mentioning_id, mention.mentioned_id] }

    mentioned_ids = find_mentioned_reports(report)
    new_mentions = mentioned_ids.map { |mentioned_id| [report.id, mentioned_id.to_i] }

    mentions_to_create = (new_mentions - existing_mentions).map do |mention|
      {
        mentioning_id: mention.first,
        mentioned_id: mention.second
      }
    end

    mentions_to_create.each { |mention| Mention.create(mention) }

    destroy_mentions(report, existing_mentions, new_mentions) if mentions_to_create.blank?
  end

  def self.destroy_mentions(report, existing_mentions, new_mentions)
    destroy_report_id = existing_mentions.select { |mention| mention[0] == report.id }
    destroy_mentions = destroy_report_id - new_mentions
    destroy_mentions.each do |destroy_mention|
      mention = Mention.find_by(mentioning_id: report.id, mentioned_id: destroy_mention[1])
      mention.destroy!
    end
  end
end
