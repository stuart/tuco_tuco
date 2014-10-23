Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoDSLTest do
  use ExUnit.Case
  use TucoTuco.DSL

  setup_all do
    http_server_pid = TucoTuco.TestServer.start
    # Using chrome because phantomjs does not handle alerts.
    TucoTuco.start_session :test_browser, :tuco_test, :chrome
    on_exit fn ->
      TucoTuco.stop
      TucoTuco.TestServer.stop(http_server_pid)
    end
    {:ok, [http_server_pid: http_server_pid]}
  end

  setup do
    visit "http://localhost:8889/page_3.html"
    :ok
  end

  test "accept alert and alert text" do
    accept_alert fn ->
      click_link "Alert"
      assert "this is an alert" = alert_text
    end
    assert {:no_alert_open_error, _} = alert_text
  end

  test "dismiss confirm" do
    dismiss_confirm fn ->
      click_link "Confirm"
      assert "confirm me" = alert_text
    end
    assert {:no_alert_open_error, _} = alert_text
  end

  test "fill in and accept prompt" do
    accept_prompt "Stuart", fn ->
      click_link "Prompt"
    end
    save_screenshot "prompt.png"
    assert Page.has_text?("My name is Stuart")
  end

  test "has alert" do
    accept_alert fn ->
      click_link "Alert"
      assert has_alert?
    end
    refute has_alert?
  end
end
