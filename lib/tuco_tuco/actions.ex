defmodule TucoTuco.Actions do
  import TucoTuco.DSL
  import TucoTuco.Finder
  import TucoTuco.Retry

  @doc """
    Click a link found by id, text or label.
  """
  def click_link text do
    find_with_retry(:link, text) |> do_click
  end

  @doc """
    Click on a button found by id, value or label.
    Also clicks on form submit inputs.
  """
  def click_button text do
    find_with_retry(:button, text) |> do_click
  end

  defp do_click nil do
    {:error, "Nothing to click"}
  end

  defp do_click element do
    WebDriver.Element.click element
  end

  @doc """
    Fill in a field with the specified text.
    Finds the field by id, name or label.

    See WebDriver.Keys if you need to use non text characters.
  """
  def fill_in field, text do
    find_with_retry(:fillable_field, field) |> do_fill_in text
  end

  defp do_fill_in nil, text do
    {:error, "No field found with id, name or label specified"}
  end

  defp do_fill_in element, text do
    WebDriver.Element.value(element, text)
  end

  @doc """
    Choose a radio button.
    Finds the button by id or label.
  """
  def choose text do
    find_with_retry(:radio, text) |> do_choose
  end

  defp do_choose nil do
    {:error, "No radio button with id or label found"}
  end

  defp do_choose element do
    WebDriver.Element.click element
  end

  @doc """
    Check a checkbox.
    Finds the checkbox by id, name or label.
  """
  def check text do
    find_with_retry(:checkbox, text) |> do_check
  end

  @doc """
    Uncheck a checkbox.
    Finds the checkbox by id, name or label.
  """
  def uncheck text do
    find_with_retry(:checkbox, text) |> do_uncheck
  end

  defp do_check nil do
    {:error, "No checkbox with id, name or label found"}
  end

  defp do_check element do
    case WebDriver.Element.attribute(element, :checked) == "true" do
      true -> {:ok, "Already checked"}
      false -> do_click element
    end
  end

  defp do_uncheck nil do
    {:error, "No checkbox with id, name or label found"}
  end

  defp do_uncheck element do
    case WebDriver.Element.attribute(element, :checked) == "true" do
      true -> do_click element
      false -> {:ok, "Already un-checked"}
    end
  end

  @doc """
    Select an option from a select.
    Finds the option by it's text or id.
  """
  def select text do
    find_with_retry(:option, text) |> do_click
  end

  @doc """
    Select an option from a specified select.
    Finds the option from it's text or id and finds the select
    from it's id, name or label.
  """
  def select text, from: sel do
    find_with_retry(:option, text, sel) |> do_click
  end

  defp do_select nil do
    {:error, "No option found."}
  end

  defp do_select element do
    do_click element
  end

  @doc """
    Currently not working. Do not use.
  """
  def unselect text do
    find_with_retry(:option, text) |> do_select
  end

  @doc """
    Attach a file to a file field.
    Finds the field by name, id or label.

    Filename must specify the path to a file that exists.
  """
  def attach_file text, filename do
    if File.exists?(filename) do
      find_with_retry(:file_field, text) |> WebDriver.Element.value(filename)
    else
      {:error, "File not found: #{filename}"}
    end
  end
end
