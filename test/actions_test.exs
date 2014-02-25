Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoActionsTest do
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

  test "click_link via text" do
    click_link "Page 2"
    assert current_path == "/page_2.html"
  end

  test "click_link via id" do
    click_link "p2"
    assert current_path == "/page_2.html"
  end

  test "clicking a link that does not exist" do
    resp = click_link "not_a_link"
    assert resp === {:error, "Nothing to click"}
  end

  test "click a button via text" do
    assert {:ok, _resp} = click_button "Button"
  end

  test "click a button via id" do
    assert {:ok, _resp} = click_button "b1"
  end

  @tag :wip
  test "click a submit button" do
    assert {:ok, _resp} = click_button "Submit"
  end

  test "click a button that does not exist" do
    resp = click_button "not_a_button"
    assert resp === {:error, "Nothing to click"}
  end

  test "fill in field by id" do
    assert {:ok, _} = fill_in "f1", with: "Bob"
  end

  test "fill in field by label" do
    assert {:ok, _} = fill_in "Name", with: "Bill"
  end

  defp visit_index do
    visit "http://localhost:8889/index.html"
  end
end
