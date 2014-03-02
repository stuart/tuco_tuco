defmodule TucoTuco.Retry do
  @doc """
    Retry a function until either it returns true, {:ok, _} or an element,
    or the number of retries greater than TucoTuco.max_retries.

    Delays between each retry for ```TucoTuco.retry\_delay``` milliseconds.
    It does not use retries if ```TucoTuco.use\_retry``` is false, which is the
    default.
  """
  def retry(fun) do
    if TucoTuco.use_retry do
      case fun.() do
        false       -> retry fun, 0
        nil         -> retry_element fun, 0
        {:error, _} -> retry_response fun, 0
        true        -> true
        {:ok, response} -> {:ok, response}
        element     -> element
      end
    else
      fun.()
    end
  end

  defp retry fun, count do
    if count >= TucoTuco.max_retries do
      false
    else
      do_retry fun, count
    end
  end

  defp do_retry fun, count do
    if fun.() do
      true
    else
      :timer.sleep(TucoTuco.retry_delay)
      retry fun, count + 1
    end
  end

  defp retry_element fun, count do
    if count >= TucoTuco.max_retries do
      nil
    else
      case fun.() do
        nil ->
          :timer.sleep(TucoTuco.retry_delay)
          retry_element(fun, count + 1)
        element -> element
      end
    end
  end

  defp retry_response fun, count do
    if count >= TucoTuco.max_retries do
      {:error, "Cannot find element."}
    else
      case fun.() do
        {:error, _} ->
          :timer.sleep(TucoTuco.retry_delay)
          retry_response(fun, count + 1)
        {:ok, response} -> {:ok, response}
      end
    end
  end
end

