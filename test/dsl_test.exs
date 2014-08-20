Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoDSLTest do
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
    visit_index
    :ok
  end

  defp visit_index do
    visit "http://localhost:8889/index.html"
  end

  test "visit a url" do
    assert current_url == "http://localhost:8889/index.html"
  end

  test "visit a relative url appends the app host" do
    TucoTuco.app_root "http://localhost:8889"
    visit "page_2.html"
    assert current_path == "/page_2.html"
  end

  test "current host" do
    assert current_host == "localhost"
  end

  test "current port" do
    assert current_port == 8889
  end

  test "go back" do
    click_link "Page 2"
    go_back
    assert current_path == "/index.html"
  end

  test "go forward" do
    click_link "Page 2"
    go_back
    go_forward
    assert current_path == "/page_2.html"
  end

  test "execute javascript" do
    assert execute_javascript "return 21 * 2" == 42
  end

  test "execute javascript with arguments" do
    assert execute_javascript("return arguments[0] * arguments[1]", [6,9]) == 54
  end

  test "execute javascript that returns a string" do
    assert execute_javascript("return 'a string'") == "a string"
  end

  test "execute javascript that returns a list" do
    assert execute_javascript("return [1,2,3]") == [1,2,3]
  end

  test "execute javascript that returns an object" do
    assert execute_javascript("return {'foo':'bar','bar':'baz'}") == %{"foo" => "bar", "bar" => "baz"}
  end

  test "execute javascript returning a page element" do
    click_link "Page 2" # Page 2 has JQuery
    assert  %WebDriver.Element{id: _, session: :tuco_test} = execute_javascript("return $('a#appear')[0]")
  end

  test "execute javascript returning an array of elements" do
    click_link "Page 2"
    assert  [%WebDriver.Element{id: _, session: :tuco_test},
             %WebDriver.Element{id: _, session: :tuco_test}] = execute_javascript("return $('p')")
  end

  test "make sure that elements from Javascript can be used in other calls" do
    click_link "Page 2"
    [e1|_] = execute_javascript("return $('p')")
    assert "Clicking the link shows text with a delay." == Element.text e1
  end

  test "returning javascript errors" do
    assert {:error, "There is possibly an error in your Javascript.", _} = execute_javascript("return foo")
  end

  test "execute async javascript" do
    assert execute_async_javascript("return arguments[0] * arguments[1]", [6,9]) == 54
  end

  test "take a screenshot writes a png file" do
    path = "/tmp/screenshot.png"
    File.rm path
    save_screenshot path
    assert File.exists? path
  end

  test "the screenshot is a png file" do
    path = "/tmp/screenshot.png"
    File.rm path
    save_screenshot path
    {:ok, data} = File.read(path)
    assert <<137,80,78,71,13,10,26,10, _::binary>> = data
  end
end
