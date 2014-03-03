defmodule TucoTuco.Retry do
  @doc """
    Retry a function until either it returns true, {:ok, _} or an element,
    or the number of retries greater than TucoTuco.max_retry_time.

    Delays between each retry for ```TucoTuco.retry\_delay``` milliseconds.
    It does not use retries if ```TucoTuco.use\_retry``` is false, which is the
    default.
  """
  def retry fun do
    if TucoTuco.use_retry do
      case fun.() do
        false       -> retry fun, :erlang.now #TucoTuco.max_retry_time
        nil         -> retry fun, :erlang.now #TucoTuco.max_retry_time
        {:error, _} -> retry fun, :erlang.now #TucoTuco.max_retry_time
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

  defp retry fun, start_time do
    if :timer.now_diff(:os.timestamp, start_time) > (TucoTuco.max_retry_time * 1000) do
      fun.()
    else
      case fun.() do
        false ->
           :timer.sleep(TucoTuco.retry_delay)
           retry fun, start_time
        nil ->
          :timer.sleep(TucoTuco.retry_delay)
          retry fun, start_time
        {:error, _} ->
          :timer.sleep(TucoTuco.retry_delay)
          retry fun, start_time
        something -> something
       end
     end
  end
end
