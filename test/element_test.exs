Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoElementTest do
  use ExUnit.Case
  use TucoTuco.DSL

  setup_all do
    http_server_pid = TucoTuco.TestServer.start
    TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    TucoTuco.app_root "http://localhost:8889"
    on_exit fn ->
      TucoTuco.stop
      TucoTuco.TestServer.stop(http_server_pid)
    end
    {:ok, [http_server_pid: http_server_pid]}
  end

  setup do
    {:ok, _} = visit("index.html")
    :ok
  end

  test "getting an element's attributes" do
    ref = TucoTuco.Finder.find(:id, "p1")
    assert Element.attribute(ref, :id) == "p1"
    assert Element.attribute(ref, :href) == "http://localhost:8889/page_1.html"
  end

  test "clicking on an element" do
    ref = TucoTuco.Finder.find(:id, "p1")
    Element.click ref
    assert current_path == "/page_1.html"
  end

  test "fill and clear an element" do
    ref = TucoTuco.Finder.find(:id, "message")
    Element.value ref, "This is my message."
    assert Element.attribute(ref, :value) == "This is my message."
    Element.clear ref
    assert Element.attribute(ref, :value) == ""
  end

  test "get css value for an element" do
    ref = TucoTuco.Finder.find(:id, "message")
    assert Element.css(ref, "background-color") == "rgba(0, 0, 0, 0)"
  end
end
