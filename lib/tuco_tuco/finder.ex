defmodule TucoTuco.Finder do
  import TucoTuco.DSL

  def find :link, text_or_id do
    case WebDriver.Session.element(current_session, :id, text_or_id) do
      nil ->
        elem = WebDriver.Session.element(current_session, :link, text_or_id)
      element -> element
    end
  end

  def find :button, text_or_id do
    case WebDriver.Session.element(current_session, :id, text_or_id) do
      nil ->
        xpath = "//button[contains(., '#{text_or_id}')]"
        elem = WebDriver.Session.element(current_session, :xpath, xpath)
      element -> element
    end
  end

  def find :fill_field, label_or_id do
  end


end
