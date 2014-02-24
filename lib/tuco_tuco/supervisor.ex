defmodule TucoTuco.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link {:local, :tucotuco}, __MODULE__, []
  end

  def init([]) do
    workers = [ worker(TucoTuco.SessionPool, []) ]
    supervise workers, strategy: :one_for_one
  end
end
