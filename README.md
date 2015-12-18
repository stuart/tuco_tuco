# TucoTuco
[![Build Status](https://travis-ci.org/stuart/tuco_tuco.png?branch=master)](https://travis-ci.org/stuart/tuco_tuco)

Testing for Elixir web applications.

TucoTuco helps you test your web application by running a web browser
and simulating user interaction with your application.

With a DSL approximating that of Capybara's, it should be
easy for developers to write tests for a web application.

## Setup
In your mix.exs add the following to the test environment deps:

    {:tuco_tuco, "~>0.7.1", only: test}

Either specify tuco_tuco in your application block in mix.exs or do:

    :application.start TucoTuco

## Requirements
Testing requires that you have Phantomjs, Firefox or ChromeDriver installed.
The WebDriver library will also prompt you to install the Firefox plugin with
`mix webdriver.firefox.plugin` if it is not present.
You can also test against a remote WebDriver server such as a Selenium instance.

## Documentation
Here is a rough guide to using TucoTuco.

### Starting A Session
  Import the DSL functionality with:

```
use TucoTuco.DSL
```

  Start a session with:

```
TucoTuco.start_session :browser_name, :session_name, :browser_type
```

  Where browser_name and session_name are atoms to reference the running
  browser and session with later and browser_type is one of

    * :phantomjs
    * :firefox
    * :chromedriver
    * :remote

### Navigation
  Visit sends the browser to other pages.

```elixir
  visit "http://elixir-lang.org"
  visit "/login"
```

  Relative urls will be appended with the TucoTuco.app_root value.

  You can go back and forward in the browser history:

```elixir
  go_forward
  go_back
```

  And query the current url:

```elixir
current_url
current_path
current_query
current_port
```

### Clicking
  You can click on a link or button with the `click_link` and
`click_button` commands.

```elixir
  click_link "Home"
  click_link "i3"
  click_button "Back"
  click_button "Submit"
```

  Yet to come: mouse movements.

### Forms
  Interacting with forms is easy with TucoTuco's functions for that:

```elixir
  fill_in "Login", "Stuart"
  fill_in "Password", "secret_password"
  click_button "Submit"
  choose "A radio button"
  select "Carrot"
  select "Tomato", from: "Vegetables"
  check "A Checkbox"
```

  You can even attach files:

```elixir
  attach_file "Upload Picture", "path/to/my_photo.png"
```

### Querying
  Getting information about the page to use in assertions:

```elixir
  Page.has_css? "table thead tr.header"
  Page.has_xpath? "//foo/bar[@name='baz']"
  Page.has_text? "Some text from the page"
  Page.has_link? "Back"
```

  With 'has_css?` and `has_xpath?` you can specify a count
  of how many should be found.

```elixir
  # Check that there are 5 rows in the table.
  Page.has_css? "table tbody tr", count: 5
```

  There are many more. Check the documentation for them.

### Assertions
  TucoTuco supplies two assertions that you can use directly in tests:

```elixir
  assert_selector :xpath, "//foo/bar"
  refute_selector :xpath, "//baz[@class='bob']"
```

### Finder
  Finder return elements from the DOM.

```elixir
  Finder.find :id, "foo"
  Finder.find :css, ".bar"
  Finder.find :xpath, "//foo/bar"
```

  Find returns an Element record.

### Elements
  The following functions for manipulating elements are imported from
  WebDriver, they all take a WebDriver.Element struct as the
  first argument. Luckily that is exactly what all the finders return:

```elixir
  Element.attribute reference, :a_html_attribute
  Element.clear reference
  Element.click reference
  Element.css reference, "some-css-property-name"
  Element.displayed? reference
  Element.enabled? reference
  Element.equals? reference, other_reference
  Element.location? reference
  Element.location_in_view? reference
  Element.name reference
  Element.selected? reference
  Element.size reference
  Element.submit reference
  Element.text reference
  Element.value reference, "value to set"
```

  For more detailed docs on the Element functions see
  [WebDriver.Element](http://stuart.github.io/elixir-webdriver/WebDriver.Element.html).

### Javascript
  Javascript can be run using the `execute_javascript` and `execute_async_javascript`
  commands.

```elixir
  iex> execute_javascript "return argument[0] * 10", [3]
  iex> 30
```

### Retrying
  When you are testing applications that have Javascript modifying the page
  it is possible that elements will not be available when you want them because
  the browser script takes some time to run.

  To alleviate this TucoTuco has retry settings. When retry is turned on all the
  Page.has_foo? and action functions will retry for a set number of times before failing.

  You can also use the retry function yourself like this:

```elixir
  # Find elements
  TucoTuco.Finder.find using, selector

  # Any function
  TucoTuco.Retry.retry fn -> my_function(args) end
```

  Changing retry settings:

```elixir
  # Set retries on
  TucoTuco.use_retries true
  # Set the maximum retry time in milliseconds.
  TucoTuco.max_retry_time 1000
  # Set the delay between retries in milliseconds.
  TucoTuco.retry_delay 20
```

### Multiple Sessions
  You can run multiple sessions on different browser or on the same browser.
  To start a session use:

    TucoTuco.start_session :browser_name, :session_name, browser_type

  Where the browser type is one of :phantomjs, :firefox or :chrome.
  If the process :browser_name is already running the session will be started on
  that, otherwise a new browser will start running.

  Once you have multiple sessions running you can swap sessions with:

    TucoTuco.session :new_session

  And to get a list of sessions that are running:

    TucoTuco.sessions


### Screenshot
   When the driver supports it, you can take a screenshot and
   save it as a PNG file.

    save_screenshot "path/to/file.png"

Example Session from console:

```elixir
    iex(1)> use TucoTuco.DSL
    :ok
    iex(2)> TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
    {:ok,
     %TucoTuco.SessionPool.SessionPoolState{app_root: nil,
      current_session: :tuco_test, max_retry_time: 2000, retry_delay: 50,
      use_retry: false}}
    iex(3)> visit "http://elixir-lang.org"
    {:ok,
     %WebDriver.Protocol.Response{request: %WebDriver.Protocol.Request{body: "{\"url\":\"http://elixir-lang.org\"}",
       headers: ["Content-Type": "application/json;charset=UTF-8",
        "Content-Length": 32], method: :POST,
       url: "http://localhost:57491/wd/hub/session/4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7/url"},
      session_id: "4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7", status: 0, value: %{}}}
    iex(4)> click_link "getting started guide"
    {:ok,
     %WebDriver.Protocol.Response{request: %WebDriver.Protocol.Request{body: "{}",
       headers: ["Content-Type": "application/json;charset=UTF-8",
        "Content-Length": 2], method: :POST,
       url: "http://localhost:57491/wd/hub/session/4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7/element/:wdc:1408353394161/click"},
      session_id: "4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7", status: 0, value: %{}}}
    iex(5)> current_url
    "http://elixir-lang.org/getting_started/1.html"
    iex(6)> Page.has_css? "article h1#toc_0"
    false
    iex(7)> Page.has_text? "Elixir also supports UTF-8 encoded strings:"
    false
    iex(8)> click_link "Next →"
    {:ok,
     %WebDriver.Protocol.Response{request: %WebDriver.Protocol.Request{body: "{}",
       headers: ["Content-Type": "application/json;charset=UTF-8",
        "Content-Length": 2], method: :POST,
       url: "http://localhost:57491/wd/hub/session/4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7/element/:wdc:1408353427808/click"},
      session_id: "4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7", status: 0, value: %{}}}
    iex(9)> current_url
    "http://elixir-lang.org/getting_started/2.html"
    iex(10)>  Page.has_xpath? "//h1[.='2 Diving in']"
    false
    iex(11)> go_back
    {:ok,
     %WebDriver.Protocol.Response{request: %WebDriver.Protocol.Request{body: "{}",
       headers: ["Content-Type": "application/json;charset=UTF-8",
        "Content-Length": 2], method: :POST,
       url: "http://localhost:57491/wd/hub/session/4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7/back"},
      session_id: "4dc0b3b0-26b8-11e4-85b9-7b8e9f3c77e7", status: 0, value: %{}}}
    iex(12)> current_path
    "/getting_started/1.html"
```

## Using with Phoenix

Here are some preliminary instructions for using TucoTuco for
testing Phoenix applications.

### Dependencies

Edit mix.exs to include the tuco_tuco dependency and to start TucoTuco in test mode.

```elixir
  def application do
    [
      mod: { Photuco, [] },
      applications: applications(Mix.env)
    ]
  end

  defp applications do
    [:phoenix, :cowboy]
  end

  defp applications :test do
    applications ++ [:tuco_tuco]
  end

  defp applications _ do
    applications
  end

  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix"},
      {:cowboy, "~> 1.0.0"},
      {:tuco_tuco, "~>0.7.1"}
    ]
  end
```

### Test Setup

Add the setup block for the tests in the foo_test.exe file

```elixir
  setup_all do
    router = Phoenix.Project.module_root.Router
    port = Phoenix.Config.get([router,:port])
    router.start

    {:ok, _} = TucoTuco.start_session :test_browser, :test_session, :firefox
    TucoTuco.app_root "http://localhost:#{port}"

    on_exit fn -> TucoTuco.stop end
    :ok
  end
```

### Changelog
2014-10-30
  * 0.7.1
  * Made password inputs fillable
  
2014-10-23
  * 0.7.0
  * Add alert handling code

2014-10-21
  * 0.6.1
  * Bump Webdriver version to 0.6.1

2014-08-20
  * 0.6.0
  * Webdriver 0.6.0

2014-08-17
  * 0.5.1
  * Webdriver 0.5.2
  * Use hex.pm for deps

2014-08-12
  * 0.5.0
  * Elixir-0.15.0
  * Webdriver 0.5.0

2014-03-06
  * 0.4.0
  * Added save_screenshot

2014-03-04
  * 0.3.0
  * Added execute_javascript and execute_async_javascript

2014-03-02
  * 0.2.1
  * Element functions from WebDriver
  * Retries
