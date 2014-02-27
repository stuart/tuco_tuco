Code.require_file "test_server.exs", __DIR__

defmodule TucoTucoActionsTest do
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
    {:ok, _} = visit_index
    :ok
  end

# Click links
  test "click_link via text" do
    click_link "Page 2"
    assert current_path == "/page_2.html"
  end

  test "click_link via id" do
    click_link "p2"
    assert current_path == "/page_2.html"
  end

  test "clicking a link that does not exist" do
    resp = click_link "not_a_link"
    assert resp === {:error, "Nothing to click"}
  end

  test "click a button via text" do
    assert {:ok, _resp} = click_button "Button"
  end

  test "click a button via id" do
    assert {:ok, _resp} = click_button "b1"
  end

  test "click a submit button by value" do
    assert {:ok, _resp} = click_button "Click"
  end

  test "click a submit button by id" do
    assert {:ok, _resp} = click_button "b2"
  end

  test "click a button that does not exist" do
    resp = click_button "not_a_button"
    assert resp === {:error, "Nothing to click"}
  end

# Fill in fields
  test "fill in field by id" do
    assert {:ok, _} = fill_in "i1", "Bob"
  end

  test "fill in field by name" do
    assert {:ok, _} = fill_in "name", "Bill"
  end

  test "fill in field by label" do
    assert {:ok, _} = fill_in "Name", "Frank"
  end

  test "fill in a text area" do
    assert {:ok, _} = fill_in "Message", "This is my special message to you!"
  end

  test "fill in a non existent field" do
    assert {:error, "No field found with id, name or label specified"} == fill_in "not_a_field", "Foo"
  end

  test "fill in an element that is not a field" do
    assert {:error, "No field found with id, name or label specified"} = fill_in "b1", "Frank"
  end

# Choose Radio Buttons
  test "choose a radio button by id" do
    assert {:ok, _} = choose "male"
    element = WebDriver.Session.element current_session, :id, "male"
    assert WebDriver.Element.attribute(element, :checked) == "true"
    element = WebDriver.Session.element current_session, :id, "female"
    assert WebDriver.Element.attribute(element, :checked) == :null
  end

  test "choose a radio button by label" do
    assert {:ok, _} = choose "Female"
    element = WebDriver.Session.element current_session, :id, "male"
    assert WebDriver.Element.attribute(element, :checked) == :null
    element = WebDriver.Session.element current_session, :id, "female"
    assert WebDriver.Element.attribute(element, :checked) == "true"
  end

  test "choose a non existent radio button" do
    assert {:error, "No radio button with id or label found"} = choose "Neuter"
  end

  test "choose something that is not a radio button" do
    assert {:error, "No radio button with id or label found"} = choose "b1"
  end


  defp visit_index do
    visit "http://localhost:8889/index.html"
  end
end
