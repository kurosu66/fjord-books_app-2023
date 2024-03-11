# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    alice_report = reports(:by_alice)

    assert alice_report.editable?(users(:alice))
    assert_not alice_report.editable?(users(:bob))
  end

  test '#created_on' do
    report = reports(:by_alice)
    report.created_at = '2024-02-27 21:00'.in_time_zone
    assert_equal '2024-02-27 21:00'.to_date, report.created_on
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

    carol = users(:carol)
    carol_report = carol.reports.create!(title: 'carol_report', content: 'ほかでも単にして根ざしましないですますて。')
    bob_report.update!(title: 'updated_bob_report', content: "日報を更新します。http://localhost:3000/reports/#{alice_another_report.id} Carolの言及を追加 http://localhost:3000/reports/#{carol_report.id}")

    assert_includes bob_report.mentioning_reports.reload, alice_another_report
    assert_includes bob_report.mentioning_reports, carol_report
  end
end
