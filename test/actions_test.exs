Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoActionsTest do
  use ExUnit.Case
  use TucoTuco.Case

  setup_all do
    http_server_pid = TucoTuco.TestServer.start
    TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    {:ok, [http_server_pid: http_server_pid]}
  end

  teardown_all meta do
    TucoTuco.stop
    TucoTuco.TestServer.stop(meta[:http_server_pid])
  end

  test "click_link via text" do
    visit_index
    click_link "Page 2"
    assert current_path == "http://localhost:8889/page_2.html"
  end

  test "click_link via id" do
    visit_index
    click_link "p2"
    assert current_path == "http://localhost:8889/page_2.html"
  end

  test "clicking a link that does not exist" do
    visit_index
    resp = click_link "not_a_link"
    assert resp === {:error, "Nothing to click"}
  end

  test "click a button via text" do
    visit_index
    assert {:ok, _resp} = click_button "Button"
  end

  test "click a button via id" do
    visit_index
    assert {:ok, _resp} = click_button "b1"
  end

  test "click a button that does not exist" do
    visit_index
    resp = click_button "not_a_button"
    assert resp === {:error, "Nothing to click"}
  end

  test "attach file" do
    visit index

  end


  defp visit_index do
    visit "http://localhost:8889/index.html"
  end
end
