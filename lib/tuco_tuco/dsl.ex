defmodule TucoTuco.DSL do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      import TucoTuco.Actions
      import TucoTuco.Assertions
      alias TucoTuco.Finder, as: Finder
      alias TucoTuco.Page, as: Page
      alias WebDriver.Element, as: Element
      :ok
    end
  end

  @doc """
    Send the browser to the specified url.

    If a relative url is specified it will be prepended with the TucoTuco.app_root
  """
  def visit url do
    if Regex.match?(~r{^http}, url) do
      WebDriver.Session.url current_session, url
    else
      WebDriver.Session.url current_session, "#{TucoTuco.app_root}/#{url}"
    end
  end

  @doc """
    Send the browser forward in history.
  """
  def go_forward do
    WebDriver.Session.forward current_session
  end

  @doc """
    Send the browser backward in history.
  """
  def go_back do
    WebDriver.Session.back current_session
  end

  defp __uri__ do
    URI.parse(current_url)
  end

  @doc """
    Returns the current url as a string.
  """
  def current_url do
    WebDriver.Session.url(current_session)
  end

  @doc """
    Returns the host part of the current url.
  """
  def current_host do
    __uri__.host
  end

  @doc """
    Returns the path portion of the current url.
  """
  def current_path do
    __uri__.path
  end

  @doc """
    Returns the port part of the current url.
  """
  def current_port do
    __uri__.port
  end

  @doc """
    Returns the query portion of the current url.
  """
  def current_query do
    __uri__.query
  end

  @doc """
    Returns the name or pid of the current TucoTuco session.
  """
  def current_session do
    TucoTuco.current_session
  end

  @doc """
    Executes javascript in the page.

    The arguments can be referred to in the script by referencing
    the Javascript array called ```arguments```.

    Return values can be:

      * :null
      * A number.
      * A string.
      * A WebDriver.Element struct.
      * A tuple list (Javacript object.)
      * A list of any of these.

    Example:

    ```
      assert "Hello World" == execute_javascript("return argument[0] + argument[1]", ["Hello","World"])
    ```

  """
  def execute_javascript script, arguments \\ [] do
    WebDriver.Session.execute(current_session, script, arguments) |> handle_js_response
  end

  @doc """
    Executes javascript in the page. This executes the javascript asynchronously
    and returns when the callback is called which will be injected as the last
    argument to the function.
  """
  def execute_async_javascript script, arguments \\ [] do
    WebDriver.Session.execute(current_session, script, arguments) |> handle_js_response
  end

  defp handle_js_response {:unknown_error, response} do
    {:error, "There is possibly an error in your Javascript.", response}
  end

  defp handle_js_response {:javascript_error, response} do
    {:error, "There is an error in your javascript.", response}
  end

  defp handle_js_response [%{"ELEMENT" => id}] do
    handle_js_response(%{"ELEMENT" => id})
  end

  defp handle_js_response [%{"ELEMENT" => id} | tail ] do
    [ handle_js_response(%{"ELEMENT" => id}),  handle_js_response tail ]
  end

  defp handle_js_response %{"ELEMENT" => id} do
    %WebDriver.Element{id: id, session: current_session}
  end

  defp handle_js_response response do
    response
  end

  @doc """
    Saves a PNG screenshot at the path specified.
    Returns ```:ok``` if successful or ```{:error, reason}``` if there
    is an error.
  """
  def save_screenshot file_path do
    case WebDriver.Session.screenshot(current_session) do
      {:error, reason} -> {:error, reason}
      data             -> File.write(file_path, :base64.decode(data))
    end
  end

  @doc """
    Accept an alert that comes up.

    Note that alerts, prompts and dialogs will prevent interaction with
    the page whilst they are open so any actions that open one
    must be wrapped in an `accept_alert`, `accept_prompt` or `dismiss_confirm`
    call.

    Example:

      accept_alert fn ->
        click("Show Alert")
      end
  """
  def accept_alert f do
    f.()
    WebDriver.Session.accept_alert current_session
  end

  @doc """
    Return the text contained in an alert.

    Example:

      accept_alert fn ->
        click("Show Alert")
        assert "this is an alert" = alert_text
      end
  """
  def alert_text do
    WebDriver.Session.alert_text current_session
  end

  @doc """
    Dismiss a confirmation dialog. This is the equivalent to clicking
    on what is usually the Cancel button.

    Example:

      dismiss_confirm fn ->
        click("Show Confirmation")
      end
  """
  def dismiss_confirm f do
    f.()
    WebDriver.Session.dismiss_alert current_session
  end

  @doc """
    Accept a prompt and fill it in with the text given.

    Example:

      accept_prompt "Elixir is Great", fn ->
        click_link("Prompt me")
      end
  """
  def accept_prompt text, f do
    f.()
    WebDriver.Session.alert_text current_session, text
    WebDriver.Session.accept_alert current_session
  end

  @doc """
    True or false depending on if a prompt, alert or confirm
    dialog is currently open on the page.
  """
  def has_alert? do
    case alert_text do
      s when is_binary(s)       -> true
      {:no_alert_open_error, _} -> false
      _ -> false
    end
  end
end
