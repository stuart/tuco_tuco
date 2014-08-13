defmodule TucoTuco.SessionPool do
  use GenServer.Behaviour

  @moduledoc """
    The session pool is responsible for maintaining state which references
    the underlying WebDriver sessions that are running.
  """

  defmodule SessionPoolState do
    defstruct current_session: nil,
              app_root: nil,
              use_retry: false,
              max_retry_time: 2000,
              retry_delay: 50
  end


  def start_link do
    state = %SessionPoolState{}
    :gen_server.start_link({:local, :tuco_tuco},__MODULE__, state, [])
  end

  def init _ do
    {:ok, %SessionPoolState{}}
  end

  def handle_call {:current_session, new_session}, _sender, state do
    case :lists.member( new_session, WebDriver.sessions ) do
      true -> new_state = %{state | current_session: new_session}
        {:reply, {:ok, new_state.current_session}, new_state}
      false -> {:reply, {:error, "Session :#{new_session} is not running."}, state}
    end
  end

  def handle_call :current_session, _sender, state do
    # Reset to nil if the session is not running any more.
    if :lists.member( state.current_session, WebDriver.sessions ) do
      {:reply, {:ok, state.current_session}, state}
    else
      {:reply, {:ok, nil}, %{state | current_session: nil}}
    end
  end

  def handle_call :app_root, _sender, state do
    {:reply, {:ok, state.app_root}, state}
  end

  def handle_call {:app_root, new_app_root}, _sender, state do
    state = %{state | app_root: new_app_root}
    {:reply, {:ok, state}, state}
  end

  def handle_call :sessions, _sender, state do
    {:reply, { :ok, WebDriver.sessions }, state}
  end

  def handle_call :use_retry, _sender, state do
    {:reply, {:ok, state.use_retry}, state}
  end

  def handle_call({:use_retry, value}, _sender, state) when is_boolean(value) do
    state = %{state | use_retry: value}
    {:reply, {:ok, state}, state}
  end

  def handle_call :max_retry_time, _sender, state do
    {:reply, {:ok, state.max_retry_time}, state}
  end

  def handle_call({:max_retry_time, value}, _sender, state) when is_integer(value) and value > 0 do
    state = %{state | max_retry_time: value}
    {:reply, {:ok, state}, state}
  end

  def handle_call :retry_delay, _sender, state do
    {:reply, {:ok, state.retry_delay}, state}
  end

  def handle_call({:retry_delay, value}, _sender, state) when is_integer(value) and value > 0 do
    state = %{state | retry_delay: value}
    {:reply, {:ok, state}, state}
  end

  def handle_call {:start_session, browser_config, session_name}, _sender, state do
    browsers = WebDriver.browsers
    case :lists.member(browser_config.name, browsers) do
      true ->  {:ok, _session} = WebDriver.start_session browser_config.name, session_name

      false -> WebDriver.start_browser browser_config
               {:ok, _session} = WebDriver.start_session browser_config.name, session_name
    end
    state = %{state | current_session: session_name}
    {:reply, {:ok, state}, state}
  end
end
