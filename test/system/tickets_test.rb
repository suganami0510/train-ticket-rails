require "application_system_test_case"

class TicketsTest < ApplicationSystemTestCase
  test '乗車して降車する' do
    visit root_path
    select '150円', from: '運賃'
    select 'うめだ', from: '乗車駅'
    click_button '乗る'
    assert_text '乗りました。'

    select 'みくに', from: '降車駅'
    click_button '降りる'
    assert_text 'では降車できません。'

    select 'じゅうそう', from: '降車駅'
    click_button '降りる'
    assert_text '降りました。'
  end

  test 'すでに乗車済み、未降車の切符があったら降車画面に移動する' do
    ticket = Ticket.create!(fare: 150, entered_gate: gates(:umeda))
    visit root_path
    assert_current_path edit_ticket_path(ticket)
    assert_text '降車していない切符があります。'
  end

  test 'すでに使用済みの切符を指定されたらトップページに移動する' do
    ticket = Ticket.create!(fare: 150, entered_gate: gates(:umeda), exited_gate: gates(:juso))
    visit edit_ticket_path(ticket)
    assert_current_path root_path
    assert_text '降車済みの切符です。'
  end

  test 'showにアクセスされたらeditに移動する' do
    ticket = Ticket.create!(fare: 150, entered_gate: gates(:umeda))
    visit ticket_path(ticket)
    assert_current_path edit_ticket_path(ticket)
  end
end