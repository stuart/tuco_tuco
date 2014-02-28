defmodule TucoTuco.Assertions do
  import TucoTuco.DSL
  alias TucoTuco.Page, as: Page

  require ExUnit.Assertions

  def assert_selector selector do
    assert_selector :xpath, selector
  end

  def assert_selector using, selector do
    ExUnit.Assertions.assert(Page.has_selector?(using, selector),
                      "\n\t\tExpected current page to contain #{using}: #{selector}")
  end

  def refute_selector selector do
    refute_selector :xpath, selector
  end

  def refute_selector using, selector do
    ExUnit.Assertions.refute(Page.has_selector?(using, selector),
                      "\n\t\tExpected current page to NOT contain #{using}: #{selector}")
  end
end
