Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoSynchTest do
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
    fun = fn -> d = :timer.now_diff(:erlang.now, start) > 300000 end
    assert TucoTuco.Retry.retry fun
  end

  test "retry returns false if function takes too long" do
    start = :erlang.now
    fun = fn -> :timer.now_diff(:erlang.now, start) > 3000000 end
    refute TucoTuco.Retry.retry fun
  end

  test "retry returns nil if function is always nil" do
    fun = fn -> nil end
    assert TucoTuco.Retry.retry(fun) == nil
  end

  test "retry returns an element if function returns an element" do
    fun = fn -> %WebDriver.Element{} end
    assert %WebDriver.Element{}  == TucoTuco.Retry.retry(fun)
  end

  def element_test_fun start do
    if :timer.now_diff(:erlang.now, start) > 300000 do
      %WebDriver.Element{}
    else
      nil
    end
  end

  test "retry returns an element if function eventually returns one" do
    start = :erlang.now
    assert %WebDriver.Element{}  == TucoTuco.Retry.retry(fn -> element_test_fun(start) end )
  end

  def response_test_fun start do
    if :timer.now_diff(:erlang.now, start) > 300000 do
      {:ok, "response"}
    else
      {:error, "message"}
    end
  end

  test "retry returns a response tuple if function eventually returns one" do
    start = :erlang.now
    assert {:ok, "response"} == TucoTuco.Retry.retry(fn -> response_test_fun(start) end )
  end

  test "retry returns an {:error, message} tuple if the function always returns one" do
    fun = fn -> {:error, "message"} end
    assert TucoTuco.Retry.retry(fun) == {:error, "message"}
  end

  test "has_css? with an element that is slow to appear" do
    click_link "Appear"
    assert Page.has_css?("p.text")
  end

  test "has_css? an element that is slow to disappear" do
    click_link "Disappear"
    assert Page.has_no_css?("div#magic")
  end

  test "find an element that is slow to appear" do
    click_link "Appear"
    assert Page.is_element?(TucoTuco.Finder.find_with_retry :css, "p.text")
  end

  test "find an element that never appears" do
    assert nil = TucoTuco.Finder.find_with_retry :css, "p.text"
  end

  test "click on an element that is slow to appear" do
    click_link "Appear"
    assert {:ok, _} = click_link "foo"
  end

  test "click on element that never appears" do
    assert {:error, "Nothing to click"} = click_link "foo"
  end
end
