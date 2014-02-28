Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoPageTest do
  use ExUnit.Case
  use TucoTuco.DSL

  setup_all do
    http_server_pid = TucoTuco.TestServer.start
    TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    {:ok, [http_server_pid: http_server_pid]}
  end

  teardown_all meta do
    TucoTuco.stop
    TucoTuco.TestServer.stop(meta[:http_server_pid])
  end

  setup do
    {:ok, _} = visit_index
    :ok
  end

  defp visit_index do
    visit "http://localhost:8889/index.html"
  end

  test "has_css?" do
    assert Page.has_css? "select#sel1"
  end

  test "has_css? fails " do
    refute Page.has_css? "select#foo"
  end

  test "has_xpath?" do
    assert Page.has_xpath? "/html/body/h1[.='Test Index']"
  end

  test "has_xpath? fails" do
    refute Page.has_xpath? "/html/body/h1[.='Foo Bar']"
  end

  test "has_field?" do
    assert Page.has_field? "Name"
  end

  test "has_field? fails" do
    refute Page.has_field? "Address"
  end

  test "has_link?" do
    assert Page.has_link? "Page 1"
  end

  test "has_link? fails" do
    refute Page.has_link? "Thingy"
  end

  test "has_button?" do
    assert Page.has_button? "Button"
  end

  test "has_button fails" do
    refute Page.has_button? "Name"
  end

  test "has_checked_field?" do
    check "Male"
    assert Page.has_checked_field? "Male"
    refute Page.has_checked_field? "Female"
  end

  test "has_checked_field? with nonexistent field" do
    refute Page.has_checked_field? "Foo"
  end

  test "has_select?" do
    assert Page.has_select? "Colors"
  end

  test "has_unchecked_field" do
    check "Male"
    assert Page.has_unchecked_field? "Female"
    refute Page.has_unchecked_field? "Male"
  end

  test "has_table?" do
    assert Page.has_table? "My Fantastic Stuff"
  end

  test "has_table? by id" do
    assert Page.has_table? "table1"
  end

  test "has text" do
    assert Page.has_text? "A test page for TucoTuco."
  end

  test "has text fails" do
    refute Page.has_text? "A test page for Capybara"
  end

  test "partial text match" do
    assert Page.has_text? "A test page"
  end
end
