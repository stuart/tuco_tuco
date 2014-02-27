defmodule TucoTuco.Finder do
  import TucoTuco.DSL

  def find :id, id do
    WebDriver.Session.element(current_session, :id, id)
  end

  def find :xpath, xpath do
    WebDriver.Session.element(current_session, :xpath, xpath)
  end

  def find :link, term do
    case find :id, term do
      nil ->
        WebDriver.Session.element(current_session, :link, term)
      element -> element
    end
  end

  def find :button, term do
    case find :id, term do
      nil ->
        find :xpath, "//button[contains(., '#{term}')] | //input[@type='submit'\
                      and (@value='#{term}' or @id='#{term}' or @title='#{term}')]"
      element -> element
    end
  end

  def find :fillable_field, term do
    case find :id, term do
      nil ->
        case find :xpath, "//input[@type='text' and @name='#{term}'] | //textarea[@name='#{term}']" do
          nil     -> find :field_for_label, term
          element -> element
        end
      element -> element
    end
  end

  def find :field_for_label, label do
    case find :xpath, "//label[contains(.,'#{label}')]" do
      nil     -> nil
      element -> find :id, WebDriver.Element.attribute(element, :for)
    end
  end
end
