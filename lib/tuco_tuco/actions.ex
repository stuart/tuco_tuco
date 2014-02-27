defmodule TucoTuco.Actions do
  import TucoTuco.DSL
  import TucoTuco.Finder

  def click_link text_or_id do
    find(:link, text_or_id) |> do_click
  end

  def click_button text_or_id do
    find(:button, text_or_id) |> do_click
  end

  defp do_click nil do
    {:error, "Nothing to click"}
  end

  defp do_click element do
    WebDriver.Element.click element
  end

  def fill_in field, text do
    find(:fillable_field, field) |> do_fill_in text
  end

  defp do_fill_in nil, text do
    {:error, "No field found with id, name or label specified"}
  end

  defp do_fill_in element, text do
    WebDriver.Element.value(element, text)
  end

  def choose text do
    find(:radio, text) |> do_choose
  end

  defp do_choose nil do
    {:error, "No radio button with id or label found"}
  end

  defp do_choose element do
    WebDriver.Element.click element
  end

  def check text do
    find(:checkbox, text) |> do_check
  end

  def uncheck text do
    find(:checkbox, text) |> do_uncheck
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

  def select text do
    find(:option, text) |> do_click
  end

  def select text, from: sel do
    find(:option, text, sel) |> do_click
  end

  defp do_select nil do
    {:error, "No option found."}
  end

  defp do_select element do
    do_click element
  end
end
