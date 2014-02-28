defmodule TucoTuco.DSL do

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
      import TucoTuco.Actions
      import TucoTuco.Assertions
      alias TucoTuco.Page, as: Page
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
end
