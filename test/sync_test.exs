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
    {:ok, _} = TucoTuco.use_retry true
    {:ok, _} = visit_page_2
    :ok
  end

  def visit_page_2 do
    visit "http://localhost:8889/page_2.html"
  end

  test "retry returns true if function is true" do
    fun = fn -> true end
    assert TucoTuco.Retry.retry fun
  end

  test "retry returns false if function always returns false" do
    fun = fn -> false end
    refute TucoTuco.Retry.retry fun
  end

  test "retry returns true if function eventually is true" do
    start = :erlang.now
    fun = fn -> :timer.now_diff(:erlang.now, start) > 1000 end
    assert TucoTuco.Retry.retry fun
  end

  test "retry returns false if function takes too long" do
    start = :erlang.now
    fun = fn -> :timer.now_diff(:erlang.now, start) > 3000 end
    assert TucoTuco.Retry.retry fun
  end

  test "finding an element that is slow to appear" do
    click_link "Appear"
    assert Page.has_css?("p.text")
  end

  test "not finding an element that is slow to disappear" do
    click_link "Disappear"
    assert Page.has_no_css?("div#magic")
  end
end
