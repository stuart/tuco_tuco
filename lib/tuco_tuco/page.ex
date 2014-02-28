defmodule TucoTuco.Page do
  import TucoTuco.DSL
  import TucoTuco.Finder

  @doc """
    Does the page have an element matching the specified css selector?
  """
  def has_css? css do
    has_selector? :css, css
  end

  @doc """
    Does the page have an element matching the xpath selector?
  """
  def has_xpath? xpath do
    has_selector? :xpath, xpath
  end

  @doc """
    Does the page have a text field or text area with the id, name or label?
  """
  def has_field? text do
    is_element? find(:fillable_field, text)
  end

  @doc """
    Does the page have a link containing the specified text, id or name.
  """
  def has_link? text do
    is_element? find(:link, text)
  end

  @doc """
    Does the page have a button.
    Finds by text, id or name.
  """
  def has_button? text do
    is_element? find(:button, text)
  end

  @doc """
    Does the page have a checkbox or radio button that is checked?

    Finds by label or id.
  """
  def has_checked_field? text do
    element = find(:checkbox_or_radio, text)
    case is_element?(element) do
      true -> WebDriver.Element.selected? element
      false -> false
    end
  end

  @doc """
    Does the page have a checkbox or radio button that is unchecked?

    Finds by label or id.
  """
  def has_unchecked_field? text do
    element = find(:checkbox_or_radio, text)
    case is_element?(element) do
      true -> !WebDriver.Element.selected? element
      false -> false
    end
  end

  @doc """
    Does the page have a select with the given id, name or label.
  """
  def has_select? text do
    is_element? find(:select, text)
  end

  @doc """
    Does the page have a table with the given caption or id?
  """
  def has_table? text do
    is_element? find(:table, text)
  end

  @doc """
    Does the page have an element matching the selector, using
    the strategy specified by the 'using' parameter.

   Using may be one of:

      * :class - Search for an element with the given class attribute.
      * :class_name - alias for :class
      * :css - Search for an element using a CSS selector.
      * :id - Find an element with the given id attribute.
      * :name - Find an element with the given name attribute.
      * :link - Find an link element containing the given text.
      * :partial_link - Find a link element containing a superset of the given text.
      * :tag - Find a HTML tag of the given type.
      * :xpath - Use [XPath](http://www.w3.org/TR/xpath/) to search for an element.
  """
  def has_selector? using, selector do
    is_element? WebDriver.Session.element(current_session, using, selector)
  end

  @doc """
    Does the page contain the text specified?
  """
  def has_text? text do
    is_element? find(:xpath, "//*[contains(.,'#{text}')]")
  end

  defp is_element? element do
    is_record(element, WebDriver.Element.Reference)
  end
end
