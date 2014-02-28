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

  defp visit_index do
    visit "http://localhost:8889/index.html"
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
    assert WebDriver.Element.selected? element
    element = WebDriver.Session.element current_session, :id, "female"
    refute WebDriver.Element.selected? element
  end

  test "choose a radio button by label" do
    assert {:ok, _} = choose "Female"
    element = WebDriver.Session.element current_session, :id, "male"
    refute WebDriver.Element.selected? element
    element = WebDriver.Session.element current_session, :id, "female"
    assert WebDriver.Element.selected? element
  end

  test "choose a non existent radio button" do
    assert {:error, "No radio button with id or label found"} = choose "Neuter"
  end

  test "choose something that is not a radio button" do
    assert {:error, "No radio button with id or label found"} = choose "b1"
  end

# Check checkbox
  test "check a checkbox by id" do
    {:ok, _} = check "cb1"
    box = WebDriver.Session.element current_session, :id, "cb1"
    assert WebDriver.Element.selected? box
  end

  test "check a checkbox by label" do
    {:ok, _} = check "Accept Anything"
    box = WebDriver.Session.element current_session, :id, "cb1"
    assert WebDriver.Element.selected? box
  end

  test "check does not uncheck an already checked box" do
    {:ok, _} = check "cb1"
    assert {:ok, "Already checked"} = check "cb1"
    box = WebDriver.Session.element current_session, :id, "cb1"
    assert WebDriver.Element.selected? box
  end

  test "check a non existent element" do
    assert {:error, "No checkbox with id, name or label found"} = check "nothing"
  end

  test "uncheck a checkbox" do
    {:ok, _} = check "cb1"
    {:ok, _} = uncheck "cb1"
    box = WebDriver.Session.element current_session, :id, "cb1"
    refute WebDriver.Element.selected? box
  end

  test "uncheck does not uncheck twice" do
    assert {:ok, "Already un-checked"} = uncheck "cb1"
  end

  test "uncheck a non existent element" do
    assert {:error, "No checkbox with id, name or label found"} = uncheck "nothing"
  end

# Select options
  test "selecting an option by text" do
    {:ok, _} = select "Wednesday"
    option = WebDriver.Session.element current_session, :xpath, "//option[@value='wednesday']"
    assert WebDriver.Element.selected? option
  end

  test "selecting an option by value" do
    {:ok, _} = select "tuesday"
    option = WebDriver.Session.element current_session, :xpath, "//option[@value='tuesday']"
    assert WebDriver.Element.selected? option
  end

  test "selecting an already selected option" do
    {:ok, _} = select "tuesday"
    {:ok, _} = select "tuesday"
    option = WebDriver.Session.element current_session, :xpath, "//option[@value='tuesday']"
    assert WebDriver.Element.selected? option
  end

  test "selecting an option from a certain select" do
    {:ok, _} = select "Orange", from: "fruits"
    option = WebDriver.Session.element current_session, :xpath, "//option[@value='fruit-orange']"
    assert WebDriver.Element.selected? option
  end

  test "selecting an option from a select by label" do
    {:ok, _} = select "Orange", from: "Fruits"
    option = WebDriver.Session.element current_session, :xpath, "//option[@value='fruit-orange']"
    assert WebDriver.Element.selected? option
  end

  test "selecting from a non existent option by label" do
    assert {:error, _} = select "Mango", from: "Fruits"
  end

  test "selecting from a non existent option" do
    assert {:error, _} = select "Mango"
  end

  test "selecting from a multiple select" do
    {:ok, _} = select "Hammer"
    {:ok, _} = select "Pliers"
    hammer = WebDriver.Session.element current_session, :name, "hammer"
    assert WebDriver.Element.selected? hammer
    pliers = WebDriver.Session.element current_session, :name, "pliers"
    assert WebDriver.Element.selected? pliers
    shifter = WebDriver.Session.element current_session, :name, "shifter"
    refute WebDriver.Element.selected? shifter
  end

  @tag wip: true
  test "unselect an option" do
    {:ok, _} = select "tuesday"
    {:ok, _} = unselect "tuesday"
    option = WebDriver.Session.element current_session, :xpath, "//option[@value='tuesday']"
    refute WebDriver.Element.selected? option
  end

  test "attach a file" do
    assert {:ok, _} = attach_file "Upload", "test/upload.txt"
    click_button "Click"
    assert Regex.match?(~r{upload.txt}, current_query)
  end

  @tag wip: true
  test "attach a file that does not exist" do
    assert {:error, "File not found"} = attach_file "Upload", "test/nothing.txt"
  end
end
