defmodule TucoTucoTest do
  use ExUnit.Case

  setup do
    :ok
    on_exit fn ->
      TucoTuco.stop
    end
  end

  test "current session returns nil when there is no session" do
    assert TucoTuco.current_session == nil
  end

  test "sessions returns an empty array when nothing is running" do
    {:ok, []} = TucoTuco.sessions
  end

  test "start_session starts a browser if one is not running" do
    resp = TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    assert {:ok, %TucoTuco.SessionPool.SessionPoolState{current_session: :tuco_test}} = resp
    assert WebDriver.browsers == [:test_browser]
  end

  test "current session returns a session name or pid when there is a session" do
    TucoTuco.start_session :test_browser, :test_session, :phantomjs
    assert {:ok, [:test_session]} = TucoTuco.sessions
  end

  test "start a new session and change to it" do
    TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    TucoTuco.start_session :test_browser, :tuco_test2, :phantomjs
    assert {:ok, [:tuco_test2, :tuco_test]} = TucoTuco.sessions
    assert TucoTuco.current_session == :tuco_test2
    TucoTuco.current_session :tuco_test
    assert TucoTuco.current_session == :tuco_test
  end

  test "error if a session is not running and we try to change to it" do
    resp = TucoTuco.current_session :not_a_session
    assert resp == {:error, "Session :not_a_session is not running."}
  end

  test "set use_retries" do
    {:ok, _} = TucoTuco.use_retry true
    assert TucoTuco.use_retry
  end

  test "set max_retry_time" do
    {:ok, _} = TucoTuco.max_retry_time 20
    assert TucoTuco.max_retry_time == 20
  end

  test "set retry delay" do
    {:ok, _} = TucoTuco.retry_delay 20
    assert TucoTuco.retry_delay == 20
  end

end
