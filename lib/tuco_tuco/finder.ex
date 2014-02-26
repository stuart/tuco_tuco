defmodule TucoTuco.Finder do
  import TucoTuco.DSL

  def find :link, term do
    case WebDriver.Session.element(current_session, :id, term) do
      nil ->
        WebDriver.Session.element(current_session, :link, term)
      element -> element
    end
  end

  def find :button, term do
    case WebDriver.Session.element(current_session, :id, term) do
      nil ->
        xpath = "//button[contains(., '#{term}')] | //input[@type='submit' and (@value='#{term}' or @id='#{term}' or @title='#{term}')]"
        WebDriver.Session.element(current_session, :xpath, xpath)
      element -> element
    end
  end

  def find :fill_field, term do
    case WebDriver.Session.element(current_session, :id, term) do
      nil ->
        # Try finding by name
        xpath = "//input[@type='text' and @name='#{term}'] | //textarea[@name='#{term}']"
        case WebDriver.Session.element(current_session, :xpath, xpath) do
          nil ->
            # Try finding by label
            label_xpath = "//label[contains(.,'#{term}')]"
            case WebDriver.Session.element(current_session, :xpath, label_xpath) do
              nil -> nil
              element ->
                id =  WebDriver.Element.attribute element, :for
                WebDriver.Session.element(current_session, :id, id)
            end
          element -> element
        end
      element -> element
    end
  end
end
