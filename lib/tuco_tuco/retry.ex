defmodule TucoTuco.Retry do
  @doc """
    Retry a function until either it returns true, {:ok, _} or an element,
    or the number of retries greater than TucoTuco.max_retries.

    Delays between each retry for ```TucoTuco.retry\_delay``` milliseconds.
    It does not use retries if ```TucoTuco.use\_retry``` is false, which is the
    default.
  """
  def retry fun do
    if TucoTuco.use_retry do
      case fun.() do
        false       -> retry fun, TucoTuco.max_retries
        nil         -> retry fun, TucoTuco.max_retries
        {:error, _} -> retry fun, TucoTuco.max_retries
        true        -> true
        {:ok, response} -> {:ok, response}
        element     -> element
      end
    else
      fun.()
    end
  end

  defp retry fun, 0 do
    fun.()
  end

  defp retry fun, count do
    IO.puts count
    case fun.() do
      false       ->
         :timer.sleep(TucoTuco.retry_delay)
         retry fun, count - 1
      nil         ->
        :timer.sleep(TucoTuco.retry_delay)
        retry fun, count - 1
      {:error, _} ->
        :timer.sleep(TucoTuco.retry_delay)
        retry fun, count - 1
      something -> something
     end
  end
end
