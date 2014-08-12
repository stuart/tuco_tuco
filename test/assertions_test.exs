Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoAssertionsTest do
  use ExUnit.Case
  use TucoTuco.DSL

  setup_all do
    http_server_pid = TucoTuco.TestServer.start
    TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    on_exit fn ->
      TucoTuco.stop
      TucoTuco.TestServer.stop(http_server_pid)
    end
    {:ok, [http_server_pid: http_server_pid]}
  end

  setup do
    {:ok, _} = visit_index
    :ok
  end

  defp visit_index do
    visit "http://localhost:8889/index.html"
  end

  test "assert_selector with an xpath" do
    assert_selector :xpath, "/html/body/h1[.='Test Index']"
  end

  test "assert_selector with a non existent xpath" do
    assert_raise ExUnit.AssertionError,
                 fn -> assert_selector :xpath, "/html/body/foo" end
  end

  test "assert_selector with an id" do
    assert_selector :id, "b2"
  end

  test "assert_selector with default strategy" do
    assert_selector "/html/body/h1"
  end

  test "assert_selector with css" do
    assert_selector :css, "select#sel1"
  end

  test "refute_selector with xpath" do
    refute_selector "/html/body/h4"
  end
end
