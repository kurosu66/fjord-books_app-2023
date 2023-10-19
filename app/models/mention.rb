# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report'
  belongs_to :mentioned, class_name: 'Report'

  validates :id, uniqueness: {
    scope: %i[mentioning_id mentioned_id]
  }

  def self.find_mentioned_reports(report)
    report.content.scan(%r{http:\/\/localhost:3000\/reports\/(\d+)}).flatten
  end

  def self.update_mentions(report)
    active_mentionings = report.active_mentionings
    active_mentionings.each(&:destroy)

    Report.create_mentions(report)
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
