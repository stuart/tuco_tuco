Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoSynchTest do
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
    {:ok, _} = visit_page_2
    :ok
  end

  def visit_page_2 do
    visit "http://localhost:8889/page_2.html"
  end

  test "finding an element that is slow to appear" do
    click_link "Click"
    assert Page.has_css? "p.text"
  end
end
