# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    alice_report = reports(:alice_report)

    assert alice_report.editable?(users(:alice))
    assert_not alice_report.editable?(users(:bob))
  end

  test '#created_on' do
    report = reports(:alice_report)
    assert_equal report.created_at.to_date, report.created_on
  end

  test '#save_mentions' do
    alice = users(:alice)
    alice_report = alice.reports.create!(title: 'alice_report', content: '自分が聴いだのは近頃途中でおもにないうでし。')

    bob = users(:bob)
    bob_report = bob.reports.create!(title: 'bob_report', content: "昨日こちらの日報を読みました。http://localhost:3000/reports/#{alice_report.id}")

    assert_equal [alice_report], bob_report.mentioning_reports

    alice_another_report = alice.reports.create!(title: 'alice_another_report', content: 'alice_another_report')
    bob_report.update!(title: 'updated_bob_report', content: "日報を更新します。http://localhost:3000/reports/#{alice_another_report.id}")

    assert_equal [alice_another_report], bob_report.mentioning_reports.reload
    assert_not_equal [alice_report], bob_report.mentioning_reports.reload
  end
end
