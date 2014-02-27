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
        find :xpath, "//button[contains(., '#{term}')] | \
        //input[@type='submit' and (@value='#{term}' or @title='#{term}')]"
      element -> element
    end
  end

  def find :fillable_field, term do
    case find :xpath, "//input[@type='text' and (@name='#{term}' or @id='#{term}')] | \
    //textarea[@name='#{term}' or @id='#{term}']" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  def find :field_for_label, label do
    case find :xpath, "//label[. = normalize-space('#{label}')]" do
      nil     -> nil
      element -> find :id, WebDriver.Element.attribute(element, :for)
    end
  end

  def find :radio, term do
    case find :xpath, "//input[@type='radio' and (@name='#{term}' or @id='#{term}')]" do
      nil -> find :field_for_label, term
      element -> element
    end
  end

  def find :checkbox, term do
    case find :xpath, "//input[@type='checkbox' and (@name='#{term}' or @id='#{term}')]" do
      nil -> find :field_for_label, term
      element -> element
    end
  end

  def find_all :xpath, xpath do
    WebDriver.Session.elements(current_session, :xpath, xpath)
  end
end
