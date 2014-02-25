defmodule TucoTuco.DSL do

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
      import TucoTuco.Actions
    end
  end

  def visit url do
    if Regex.match?(~r{^http}, url) do
      WebDriver.Session.url current_session, url
    else
      WebDriver.Session.url current_session, "#{TucoTuco.app_root}/#{url}"
    end
  end

  def go_forward do
    WebDriver.Session.forward current_session
  end

  def go_back do
    WebDriver.Session.back current_session
  end

  defp __uri__ do
    URI.parse(current_url)
  end

  def current_url do
    WebDriver.Session.url(current_session)
  end

  def current_host do
    __uri__.host
  end

  def current_path do
    __uri__.path
  end

  def current_port do
    __uri__.port
  end

  def current_session do
    TucoTuco.current_session
  end
end
