defmodule TucoTuco.Retry do
  @doc """
    Retry a function until either it returns true or the number of
    retries greater than TucoTuco.max_retries.

    Delays between each retry for TucoTuco.retry_delay milliseconds.
    It does not use retries if TucoTuco.use_retry is false, which is the
    default.
  """
  def retry(fun) do
    if TucoTuco.use_retry do
      case fun.() do
        false ->
          retry fun, 0
        true -> true
      end
    else
      fun.()
    end
  end

  def retry fun, count do
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
end
