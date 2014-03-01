defmodule TucoTuco.Finder do
  import TucoTuco.DSL

  @doc """
    Find an element by id
  """
  def find :id, id do
    WebDriver.Session.element(current_session, :id, id)
  end

  @doc """
    Find an element by xpath
  """
  def find :xpath, xpath do
    WebDriver.Session.element(current_session, :xpath, xpath)
  end

  @doc """
    Find a link by id or link text.
  """
  def find :link, term do
    case find :id, term do
      nil ->
        WebDriver.Session.element(current_session, :link, term)
      element -> element
    end
  end

  @doc """
    Find a button by id, contents, or a submit element by id, value or title.
  """
  def find :button, term do
    case find :id, term do
      nil ->
        find :xpath, "//button[contains(., '#{term}')] | \
        //input[@type='submit' and (@value='#{term}' or @title='#{term}')]"
      element -> element
    end
  end

  @doc """
    Find a text field or textarea by id, name or label.
  """
  def find :fillable_field, term do
    case find :xpath, "//input[@type='text' and (@name='#{term}' or @id='#{term}')] | \
    //textarea[@name='#{term}' or @id='#{term}']" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  @doc """
    Find a label element by it's content.
  """
  def find :label, term do
    find :xpath, "//label[. = normalize-space('#{term}')]"
  end

  @doc """
    Find the field for a label by the label's content.
  """
  def find :field_for_label, label do
    case find :label, label do
      nil     -> nil
      element -> find :id, WebDriver.Element.attribute(element, :for)
    end
  end

  @doc """
    Find a radio button with the given id, name or label.
  """
  def find :radio, term do
    case find :xpath, "//input[@type='radio' and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  @doc """
    Find a checkbox with the given id, name or label.
  """
  def find :checkbox, term do
    case find :xpath, "//input[@type='checkbox' and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  @doc """
    Find a file upload field with the given id, name or label.
  """
  def find :file_field, term do
    case find :xpath, "//input[@type='file' and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  @doc """
    Find either a checkbox or radio button with the given id, name or label.
  """
  def find :checkbox_or_radio, term do
    case find :xpath, "//input[(@type='checkbox' or @type='radio') and (@name='#{term}' or @id='#{term}')]" do
      nil     -> find :field_for_label, term
      element -> element
    end
  end

  @doc """
    Find a select element with the given id, name or label.
  """
  def find :select, term do
    case find :xpath, "//select[@id='#{term}' or @name='#{term}']" do
      nil -> find :field_for_label, term
      element -> element
    end
  end

  @doc """
    Find a table element with the given id, name or caption content.
  """
  def find :table, term do
    find :xpath, "//table[@id='#{term}' or @name='#{term}'] | //table/caption[.='#{term}']"
  end

  @doc """
    Find an option with the given value or content text.
  """
  def find :option, term do
    find :xpath, "//option[@value='#{term}' or .=normalize-space('#{term}')]"
  end

  @doc """
    Find either a checkbox or radio button with the given id, name or label within
    a specified select element.
  """
  def find :option, term, sel do
    label = find :label, sel
    if label != :nil do
      sel = WebDriver.Element.attribute(label, :for)
    end

    find :xpath, "//select[@id='#{sel}' or @name='#{sel}']\
                      /option[@value='#{term}' or .=normalize-space('#{term}')]"
  end

  @doc """
    Return an array of all the elements matching an xpath.
  """
  def find_all :xpath, xpath do
    WebDriver.Session.elements(current_session, :xpath, xpath)
  end
end
