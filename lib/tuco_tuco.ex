defmodule TucoTuco do
  use Application.Behaviour

  defrecord Config, browser: :phantomjs, name: nil

  def start(_type, _args) do
    {:ok, pid} = TucoTuco.Supervisor.start_link
  end

  def current_session do
    {:ok, session} = :gen_server.call :tuco_tuco, :current_session
    session
  end

  def current_session new_session do
    :gen_server.call :tuco_tuco, {:current_session, new_session}
  end

  def sessions do
    :gen_server.call :tuco_tuco, :sessions
  end

  def start_session browser_name, session_name, driver \\ :phantomjs do
    browser_config = WebDriver.Config.new(browser: driver, name: browser_name)
    :gen_server.call :tuco_tuco, {:start_session, browser_config, session_name}
  end

  def stop do
    WebDriver.stop_all_browsers
  end
end
