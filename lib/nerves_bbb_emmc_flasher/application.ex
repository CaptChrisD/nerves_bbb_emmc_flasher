defmodule NervesBbbEmmcFlasher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Children for all targets
        # Starts a worker by calling: NervesBbbEmmcFlasher.Worker.start_link(arg)
        # {NervesBbbEmmcFlasher.Worker, arg},
      ] ++ children(Nerves.Runtime.mix_target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesBbbEmmcFlasher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  defp children(:host) do
    []
  end

  defp children(_target) do
    [{NervesBbbEmmcFlasher.Flasher, []}]
  end
end
