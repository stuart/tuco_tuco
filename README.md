# TucoTuco

Testing for Elixir web applications.

TucoTuco helps you test your web application by running a web browser
and simulating user interaction with your application.

With a DSL approximating that of Capybara's, it should be
easy for developers to write tests for a web application.

## Setup
In your mix.exs add the following to the test environment deps:
   {:tucotuco, github: "stuart/TucoTuco"}

To start it add the line to your test_helper.exs:
    :application.start TucoTuco


## Requirements
Testing requires that you have Phantomjs, Firefox or ChromeDriver installed.
You can also test against a remote WebDriver server such as a Selenium instance.

## Documentation
Here is a rough guide to using TucoTuco.

### Navigation
  Visit sends the browser to other pages.

  ```elixir
    visit 'http://elixir-lang.org'
    visit '/login'
  ```

  Relative urls will be appended with the TucoTuco.app_root value.

### Clicking
  You can click on a link or button with the ```click_link``` and
  ```click_button``` commands.

  ```elixir
    click_link "Home"
    click_link "i3"
    click_button "Back"
    click_button "Submit"
  ```

### Forms

### Querying

### Assertions

## Examples of Use

Example Session from console:

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
