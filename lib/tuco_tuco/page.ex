defmodule TucoTuco.Page do
  import TucoTuco.DSL
  import TucoTuco.Finder
  import TucoTuco.Retry

  @doc """
    Does the page have an element matching the specified css selector?
  """
  def has_css? css do
    retry fn -> has_selector? :css, css end
  end

  def has_no_css? css do
    retry fn -> !has_selector?(:css, css) end
  end

  @doc """
    Does the page have an element matching the xpath selector?
  """
  def has_xpath? xpath do
    retry fn -> has_selector? :xpath, xpath end
  end

  def has_no_xpath? xpath do
    retry fn -> !has_selector? :xpath, xpath end
  end

  @doc """
    Does the page have a text field or text area with the id, name or label?
  """
  def has_field? text do
    retry fn -> is_element? find(:fillable_field, text) end
  end

  def has_no_field? text do
    retry fn -> is_not_element? find(:fillable_field, text) end
  end

  @doc """
    Does the page have a link containing the specified text, id or name.
  """
  def has_link? text do
    retry fn -> is_element? find(:link, text) end
  end

  def has_no_link? text do
    retry fn -> is_not_element? find(:link, text) end
  end

  @doc """
    Does the page have a button.
    Finds by text, id or name.
  """
  def has_button? text do
    retry fn-> is_element? find(:button, text) end
  end

  def has_no_button? text do
    retry fn -> is_not_element? find(:button, text) end
  end

  @doc """
    Does the page have a checkbox or radio button that is checked?

    Finds by label or id.
  """
  def has_checked_field? text do
    retry fn ->
      element = find(:checkbox_or_radio, text)
      case is_element?(element) do
        true -> WebDriver.Element.selected? element
        false -> false
      end
    end
  end

  def has_no_checked_field? text do
    retry fn ->
      element = find(:checkbox_or_radio, text)
      case is_element?(element) do
        true -> !WebDriver.Element.selected?(element)
        false -> true
      end
    end
  end

  @doc """
    Does the page have a checkbox or radio button that is unchecked?

    Finds by label or id.
  """
  def has_unchecked_field? text do
    retry fn ->
      element = find(:checkbox_or_radio, text)
      case is_element?(element) do
        true -> !WebDriver.Element.selected? element
        false -> false
      end
    end
  end

  def has_no_unchecked_field? text do
    retry fn ->
      element = find(:checkbox_or_radio, text)
      case is_element?(element) do
        true -> WebDriver.Element.selected? element
        false -> true
      end
    end
  end

  @doc """
    Does the page have a select with the given id, name or label.
  """
  def has_select? text do
    retry fn -> is_element? find(:select, text) end
  end

  def has_no_select? text do
    retry fn -> is_element? find(:select, text) end
  end

  @doc """
    Does the page have a table with the given caption or id?
  """
  def has_table? text do
    retry fn -> is_element? find(:table, text) end
  end

  def has_no_table? text do
    retry fn -> is_not_element? find(:table, text) end
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
    retry fn -> is_element? WebDriver.Session.element(current_session, using, selector) end
  end

  def has_no_selector? using, selector do
    retry fn -> is_not_element? WebDriver.Session.element(current_session, using, selector) end
  end

  @doc """
    Does the page contain the text specified?
  """
  def has_text? text do
    retry fn -> is_element? find(:xpath, "//*[contains(.,'#{text}')]") end
  end

  def has_no_text? text do
    retry fn -> is_not_element? find(:xpath, "//*[contains(.,'#{text}')]") end
  end

  defp is_element? element do
    is_record(element, WebDriver.Element.Reference)
  end


  defp is_not_element? element do
    !is_element? element
  end

end
