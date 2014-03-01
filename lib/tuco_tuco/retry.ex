defmodule TucoTuco.Retry do

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
