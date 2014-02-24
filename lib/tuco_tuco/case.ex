defmodule TucoTuco.Case do

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def visit url do
    WebDriver.Session.url current_session, url
  end

  def current_path do
    WebDriver.Session.url current_session
  end

  def current_session do
    TucoTuco.current_session
  end

  def click_link text_or_id do
    find_link(text_or_id) |> do_click
  end

  def click_button text_or_id do
    find_button(text_or_id) |> do_click
  end

  defp do_click nil do
    {:error, "Nothing to click"}
  end

  defp do_click element do
    WebDriver.Element.click element
  end

  defp find_link text_or_id do
    case WebDriver.Session.element(current_session, :id, text_or_id) do
      nil ->
        elem = WebDriver.Session.element(current_session, :link, text_or_id)
      element -> element
    end
  end

  defp find_button text_or_id do
    case WebDriver.Session.element(current_session, :id, text_or_id) do
      nil ->
        xpath = "//button[contains(., '#{text_or_id}')]"
        elem = WebDriver.Session.element(current_session, :xpath, xpath)
      element -> element
    end
  end
end
