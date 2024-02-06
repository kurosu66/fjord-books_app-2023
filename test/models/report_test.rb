# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  fixtures :users,:reports

  test '#editable?' do
    report = reports(:alice_report)
    target_user = report.user
    assert report.editable?(target_user)
  end

  test "#created_on" do
    report = reports(:alice_report)
    assert_equal report.created_at.to_date, report.created_on
  end

  test "#save_mentions" do
    alice = users(:alice)
    alice_report = alice.reports.create!(title: "alice_report", content: "自分が聴いだのは近頃途中でおもにないうでし。")

    bob = users(:bob)
    bob_report = bob.reports.create!(title: "bob_report", content: "昨日こちらの日報を読みました。http://localhost:3000/reports/#{alice_report.id}")

    assert bob_report.mentioning_reports.find(alice_report.id)

    alice_another_report = alice.reports.create!(title: "alice_another_report", content: "alice_another_report")
    bob_report.update!(title: "updated_bob_report", content: "日報を更新します。http://localhost:3000/reports/#{alice_another_report.id}")

    assert bob_report.mentioning_reports.find(alice_another_report.id)
    assert_not bob_report.mentioning_reports.find_by(id: alice_report.id)
  end
end
