defmodule TucoTuco.Actions do
  import TucoTuco.DSL
  import TucoTuco.Finder

  def click_link text_or_id do
    find(:link, text_or_id) |> do_click
  end

  def click_button text_or_id do
    find(:button, text_or_id) |> do_click
  end

  defp do_click nil do
    {:error, "Nothing to click"}
  end

  defp do_click element do
    WebDriver.Element.click element
  end

  def fill_in field, options do
    [with: search_term] = options
    xpath = "//input[contains(., '#{search_term}')]"
    elem = WebDriver.Session.element(current_session, :id, search_term)
    WebDriver.Element.  element
  end
end
