defmodule Tarefas.CLI do
  def main(comandos) do
    caminho_arquivo = Path.join(File.cwd!(), "tarefas.txt")

    File.write(caminho_arquivo, "", [:append])

    dados =
      File.read!(caminho_arquivo)
      |> analisar()
      |> processar()
      |> codificar()

    File.write(caminho_arquivo, dados)
  end

  def analisar(string) do
    string
    |> String.split("\n")
    |> Enum.filter(fn string -> "" != String.trim(string) end)
    |> Enum.map(fn string -> String.split(string, ",") end)
    |> Enum.map(fn [descricao, estado] -> {descricao, estado} end)
  end

  def processar(tarefas) do
  end

  def codificar(tarefas) do
    tarefas
    |> Enum.map(fn {descricao, estado} -> [descricao, estado] end)
    |> Enum.map(fn lista -> Enum.join(lista, ",") end)
    |> Enum.concat([""])
    |> Enum.join("\n")
  end
end
