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
    find(:checkbox, text) |> do_check
  end

  def do_check element do
    case WebDriver.Element.attribute(element, :checked) == "true" do
      true -> {:ok, "Already checked"}
      false -> do_click element
    end
  end
end
