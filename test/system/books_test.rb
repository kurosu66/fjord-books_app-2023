# frozen_string_literal: true

require 'application_system_test_case'
require 'test_helper'

class BooksTest < ApplicationSystemTestCase
  fixtures :users, :books

  setup do
    @book = books(:harry_potter_book)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit books_url
    assert_selector 'h1', text: '本の一覧'
  end

  test 'should create book' do
    visit books_url
    click_on '本の新規作成'

    fill_in 'タイトル', with: @book.title
    fill_in 'メモ', with: @book.memo
    fill_in '著者', with: @book.author
    click_on '登録する'

    assert_text '本が作成されました。'
    assert_text 'ハリー・ポッター'
    assert_text '1990年代のイギリスを舞台に、魔法使いの少年ハリー・ポッターの学校生活や、強大な闇の魔法使いヴォルデモートとの因縁と戦いを描いた物語。'
    assert_text 'J・K・ローリング'
  end

  test 'should update Book' do
    visit book_url(@book)
    click_on 'この本を編集', match: :first

    fill_in 'タイトル', with: 'ナルニア国物語'
    fill_in 'メモ', with: 'イギリスの作家、C・S・ルイスの全7巻からなる子供向け小説シリーズ。'
    fill_in '著者', with: 'C・S・ルイス'
    click_on '更新する'

    assert_text '本が更新されました。'
    assert_text 'ナルニア国物語'
    assert_text 'イギリスの作家、C・S・ルイスの全7巻からなる子供向け小説シリーズ。'
    assert_text 'C・S・ルイス'
  end

  test 'should destroy Book' do
    visit book_url(@book)
    click_on 'この本を削除', match: :first

    assert_text '本が削除されました。'
  end
end
