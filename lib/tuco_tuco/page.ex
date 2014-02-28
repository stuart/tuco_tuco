defmodule TucoTuco.Page do
  import TucoTuco.DSL
  import TucoTuco.Finder

  def has_css? css do
    has_selector? :css, css
  end

  def has_xpath? xpath do
    has_selector? :xpath, xpath
  end

  def has_field? text do
    is_element? find(:fillable_field, text)
  end

  def has_link? text do
    is_element? find(:link, text)
  end

  def has_button? text do
    is_element? find(:button, text)
  end

  def has_checked_field? text do
    element = find(:checkbox_or_radio, text)
    case is_element?(element) do
      true -> WebDriver.Element.selected? element
      false -> false
    end
  end

  def has_unchecked_field? text do
    element = find(:checkbox_or_radio, text)
    case is_element?(element) do
      true -> !WebDriver.Element.selected? element
      false -> false
    end
  end

  def has_select? text do
    is_element? find(:select, text)
  end

  def has_table? text do
    is_element? find(:table, text)
  end

  def has_selector? using, selector do
    is_element? WebDriver.Session.element(current_session, using, selector)
  end

  def has_text? text do
    is_element? find(:xpath, "//*[contains(.,'#{text}')]")
  end

  defp is_element? element do
    is_record(element, WebDriver.Element.Reference)
  end
end
