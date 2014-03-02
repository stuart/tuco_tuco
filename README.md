# TucoTuco
[![Build Status](https://travis-ci.org/stuart/Tuco-Tuco.png?branch=master)](https://travis-ci.org/stuart/Tuco-Tuco)

Testing for Elixir web applications.

TucoTuco helps you test your web application by running a web browser
and simulating user interaction with your application.

With a DSL approximating that of Capybara's, it should be
easy for developers to write tests for a web application.

## Setup
In your mix.exs add the following to the test environment deps:
   ```{:tucotuco, github: "stuart/TucoTuco"} ```

To start it add the line to your test_helper.exs:
    ``` :application.start TucoTuco ```


## Requirements
Testing requires that you have Phantomjs, Firefox or ChromeDriver installed.
You can also test against a remote WebDriver server such as a Selenium instance.

## Documentation
Here is a rough guide to using TucoTuco.

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
  You can click on a link or button with the ```click_link``` and
  ```click_button``` commands.

  ```elixir
    click_link "Home"
    click_link "i3"
    click_button "Back"
    click_button "Submit"
  ```

  Yet to come: clicking directly on elements and mouse movements.

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

  There are many more. Check the documentation for them.

### Assertions
  TucoTuco supplies two assertions that you can use directly in tests:

  ```elixir
    assert_selector :xpath, "//foo/bar"
    refute_selector :xpath, "//baz[@class='bob']"
  ```

### Elements
  The following functions for manipulating elements are imported from
  WebDriver, they all take a WebDriver.Element.Reference record as the
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
  Running Javascript is not yet supported, but is supported in the
  underlying WebDriver library. A simpler API is in the TODO list.

  ```elixir
    WebDriver.Session.execute current_session, "return arguments[0] * arguments[1];", [5,3]
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
    # Set the number of retries to do before permanently failing.
    TucoTuco.max_retries 10
    # Set the delay between retries in milliseconds.
    TucoTuco.retry_delay 20
  ```

### Multiple Sessions
  You can run multiple sessions on different browser or on the same browser.
  To start a session use:

  ```
    TucoTuco.start_session :browser_name, :session_name, browser_type
  ```

  Where the browser type is one of :phantomjs, :firefox or :chrome.
  If the process :browser_name is already running the session will be started on
  that, otherwise a new browser will start running.

  Once you have multiple sessions running you can swap sessions with:

  ```
    TucoTuco.session :new_session
  ```

  And to get a list of sessions that are running:
  ```
    TucoTuco.sessions
  ```

Example Session from console:
( some responses have been cut for brevity )

```elixir
  iex(1)> use TucoTuco.DSL
  :ok
  iex(2)> TucoTuco.start_session :test_browser, :tuco_test, :phantomjs
  {:ok,
   TucoTuco.SessionPool.SessionPoolState[current_session: :tuco_test,
    app_root: nil]}
  iex(3)> visit "http://elixir-lang.org"
  iex(4)> current_url
  "http://elixir-lang.org/"
  iex(5)> click_link "getting started guide"
  iex(6)> current_url
  "http://elixir-lang.org/getting_started/1.html"
  iex(7)> Page.has_css? "article h1#toc_0"
  true
  iex(8)> Page.has_text? "Elixir also supports UTF-8 encoded strings:"
  true
  iex(9)> click_link "Next →"
  iex(10)> current_url
  "http://elixir-lang.org/getting_started/2.html"
  iex(11)> Page.has_xpath? "//h1[.='2 Diving in']"
  true
  iex(15)> go_back
  iex(16)> current_path
  "/getting_started/1.html"
  iex(17)>
```
