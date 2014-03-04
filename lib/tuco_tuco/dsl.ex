defmodule TucoTuco.DSL do

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      import TucoTuco.Actions
      import TucoTuco.Assertions
      alias TucoTuco.Page, as: Page
      alias WebDriver.Element, as: Element
      alias TucoTuco.Finder, as: Finder
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
      * A WebDriver.Element.Reference record.
      * A tuple list (Javacript object.)
      * A list of any of these.

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

  defp handle_js_response [[{"ELEMENT", id}]] do
    handle_js_response([{"ELEMENT", id}])
  end

  defp handle_js_response [[{"ELEMENT", id}] | tail ] do
    [ handle_js_response([{"ELEMENT", id}]),  handle_js_response tail ]
  end

  defp handle_js_response [{"ELEMENT", id}] do
    WebDriver.Element.Reference.new(id: id, session: current_session)
  end

  defp handle_js_response response do
    response
  end
end
