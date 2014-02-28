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

  def find :label, term do
    find :xpath, "//label[. = normalize-space('#{term}')]"
  end

  def find :field_for_label, label do
    case find :label, label do
      nil     -> nil
      element -> find :id, WebDriver.Element.attribute(element, :for)
    end
  end

  def find :radio, term do
    case find :xpath, "//input[@type='radio' and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  def find :checkbox, term do
    case find :xpath, "//input[@type='checkbox' and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  def find :file_field, term do
    case find :xpath, "//input[@type='file' and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  def find :checkbox_or_radio, term do
    case find :xpath, "//input[(@type='checkbox' or @type='radio') and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  def find :select, term do
    case find :xpath, "//select[@id='#{term}' or @name='#{term}']" do
      nil -> find :field_for_label, term
      element -> element
    end
  end

  def find :table, term do
    find :xpath, "//table[@id='#{term}' or @name='#{term}'] | //table/caption[.='#{term}']"
  end

  def find :option, term do
    find :xpath, "//option[@value='#{term}' or .=normalize-space('#{term}')]"
  end

  def find :option, term, sel do
    label = find :label, sel
    if label != :nil do
      sel = WebDriver.Element.attribute(label, :for)
    end

    find :xpath, "//select[@id='#{sel}' or @name='#{sel}']\
                      /option[@value='#{term}' or .=normalize-space('#{term}')]"
  end

  def find_all :xpath, xpath do
    WebDriver.Session.elements(current_session, :xpath, xpath)
  end
end
