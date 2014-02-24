Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoCaseTest do
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

  test "visit a url" do
    visit "http://localhost:8889/index.html"
    assert current_path == "http://localhost:8889/index.html"
  end


end
