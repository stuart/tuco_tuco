defmodule TucoTuco.Assertions do
  import TucoTuco.DSL
  alias TucoTuco.Page, as: Page

  require ExUnit.Assertions

  @doc """
    Assert that the current page contains the xpath selector specified.
  """
  def assert_selector selector do
    assert_selector :xpath, selector
  end

  @doc """
    Assert that the current page contians the selector specified.

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
  def assert_selector using, selector do
    ExUnit.Assertions.assert(Page.has_selector?(using, selector),
                      "\n\t\tExpected current page to contain #{using}: #{selector}")
  end

  @doc """
    Refute the existence of an xpath in the current page with the selector specified.
  """
  def refute_selector selector do
    refute_selector :xpath, selector
  end

  @doc """
    Refute the existence of the selector in the current page using the specifiend strategy.
    See assert_selector/3 for more info on strategies.
  """
  def refute_selector using, selector do
    ExUnit.Assertions.refute(Page.has_selector?(using, selector),
                      "\n\t\tExpected current page to NOT contain #{using}: #{selector}")
  end
end
