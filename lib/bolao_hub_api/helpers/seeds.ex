defmodule BolaoHubApi.Seeds do

  def run(files) when is_list(files), do: files |> Enum.each(&(run_/1))
  def run(file) when is_binary(file), do: file |> run_
  def run(_), do: raise ArgumentError, "It has to be a list or a string(binary)"

  defp run_(file) do
    {:ok, _} = Application.ensure_all_started(:bolao_hub_api)
    Ecto.Adapters.SQL.Sandbox.checkout(BolaoHubApi.Repo)
    path = Application.app_dir(:bolao_hub_api, "priv/repo/seeds/#{file}")
    Code.eval_file(path)
  end
end
