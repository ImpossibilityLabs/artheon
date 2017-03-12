defmodule Mix.Tasks.Ssl do
    use Mix.Task
    
    @doc """
    Create SSL certificates before starting Phoenix server.
    """
    def run(domain) do
        unless File.exists?("/etc/letsencrypt/live/#{domain}/cert.pem") do
            command = "letsencrypt"
            args = ["certonly", "--standalone", "-n", "-m voronchuk@gmail.com", "-d #{domain}", "--agree-tos"]
            case System.cmd(command, args, stderr_to_stdout: true) do
                {_, 0} ->
                    IO.puts("SSL certificated generated! Starting server...")
                    :ok
                {error_message, _exit_code} ->
                    IO.puts(error_message)
                    :error
            end
        else
            IO.puts("No need to generate SSL certificates. Starting server...")
            :ok
        end
    end
end
