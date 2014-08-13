defmodule TucoTuco do
  use Application

  @moduledoc """
    TucoTuco is a web testing suite for Elixir applications.
    To use it make sure the TucoTuco application is running by specifying it
    in your mix.exs file or doing:

      :application.start :tuco_tuco

    To use the methods it exposes in an ExUnit.Case just add this line at the top:

       use TucoTuco.DSL

    Example Test Case:

        defmodule MyTest do
          use ExUnit.Case
          use TucoTuco.DSL

          setup_all do
            {:ok, _} = TucoTuco.start_session :test_browser, :test_session, :phantomjs
            TucoTuco.app_root "http://localhost:3000"
            :ok
          end

          teardown_all do
            TucoTuco.stop
          end

          test "logging in" do
            visit "/login"
            fill_in "Login", "Stuart"
            fill_in "Password", "my_secret_password"
            click_button "Log In"
            assert current_path = "/account"
            assert Page.has_text? "Successfully logged in."
          end
        end

  """

  defmodule Config do
    defstruct browser: :phantomjs, name: nil
  end

  @doc """
    Start the TucoTuco application.
  """
  def start(_type, _args) do
    {:ok, _pid} = TucoTuco.Supervisor.start_link
  end

  @doc """
    Return the pid or name of the current session
  """
  def current_session do
    {:ok, session} = :gen_server.call :tuco_tuco, :current_session
    session
  end

  @doc """
    Set the current session to a different session.
    Will error if the specified session is not running.
  """
  def current_session new_session do
    :gen_server.call :tuco_tuco, {:current_session, new_session}
  end

  @doc """
    Get a list of all the sessions that are running.
  """
  def sessions do
    :gen_server.call :tuco_tuco, :sessions
  end

  @doc """
    Return the current application root url.
  """
  def app_root do
    {:ok, app_root} = :gen_server.call :tuco_tuco, :app_root
    app_root
  end

  @doc """
    Set the application root url to a new value.
  """
  def app_root new_root do
    {:ok, _} = :gen_server.call :tuco_tuco, {:app_root, new_root}
  end

  @doc """
    Is the application set to use retries?
  """
  def use_retry do
    {:ok, use_retry} = :gen_server.call :tuco_tuco, :use_retry
    use_retry
  end

  @doc """
    Set the use_retry option. When this is set the Page methods will retry
    a number of times. This is for situations where javascript may alter page
    contents and you need to wait for changes to occur.

    Setting this will cause tests to take a bit longer to run.
  """
  def use_retry value do
    {:ok, _} = :gen_server.call :tuco_tuco, {:use_retry, value}
  end

  @doc """
    Get the maximum number of retries setting for the application
   """
  def max_retry_time do
    {:ok, max_retry_time} = :gen_server.call :tuco_tuco, :max_retry_time
    max_retry_time
  end

  @doc """
    Set the maximum number of retries for the application. This defaults to
    20. May be any integer > 0.
  """
  def max_retry_time value do
    {:ok, _} = :gen_server.call :tuco_tuco, {:max_retry_time, value}
  end

  @doc """
    Get the application's retry delay setting in milliseconds.
    This is the amount of time it sleeps before trying an operation again.
  """
  def retry_delay do
    {:ok, retry_delay} = :gen_server.call :tuco_tuco, :retry_delay
    retry_delay
  end

  @doc """
    Set the application's retry delay in milliseconds. This defaults to 50ms.
  """
  def retry_delay ms do
    {:ok, _} = :gen_server.call :tuco_tuco, {:retry_delay, ms}
  end

  @doc """
    Start a new session. If the browser with the name specified is not running
    this will start a new browser using the driver specified, and then start
    a session on that browser.

    Driver can be one of:
     * :phantomjs
     * :firefox
     * :chrome

  """
  def start_session browser_name, session_name, driver \\ :phantomjs do
    browser_config = %WebDriver.Config{browser: driver, name: browser_name}
    :gen_server.call :tuco_tuco, {:start_session, browser_config, session_name}
  end

  @doc """
    Stop all the browsers that are running and stop TucoTuco.
  """
  def stop do
    WebDriver.stop_all_browsers
  end
end
