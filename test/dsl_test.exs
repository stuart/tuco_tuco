Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoDSLTest do
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

  test "visit a url" do
    visit_index
    assert current_url == "http://localhost:8889/index.html"
  end

  test "visit a relative url appends the app host" do
    TucoTuco.app_root "http://localhost:8889"
    visit "page_2.html"
    assert current_path == "/page_2.html"
  end

  test "current host" do
    visit_index
    assert current_host == "localhost"
  end

  test "current port" do
    visit_index
    assert current_port == 8889
  end

  test "go back" do
    visit_index
    click_link "Page 2"
    go_back
    assert current_path == "/index.html"
  end

  test "go forward" do
    visit_index
    click_link "Page 2"
    go_back
    go_forward
    assert current_path == "/page_2.html"
  end

  defp visit_index do
    visit "http://localhost:8889/index.html"
  end
end
