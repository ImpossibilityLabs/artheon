defmodule Mix.Tasks.Start do
    use Mix.Task
    
    @doc """
    Bootstrap phoenix application.
    """
    def run(domain) do
        with :ok <- Mix.Tasks.Ssl.run(domain) do
            Mix.Tasks.Phoenix.Server.run([])
        else
            _ ->
                IO.puts("Failed to start Phoenix server...")
        end
    end
end
