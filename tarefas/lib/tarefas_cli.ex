defmodule Tarefas.CLI do
  def main(comandos) do
    IO.inspect(comandos)

    caminho_arquivo = Path.join(File.cwd!(), "tarefas.txt")

    File.write(caminho_arquivo, "", [:append])

    dados =
      File.read!(caminho_arquivo)
      |> decodificar()
      |> processar(comandos)
      |> codificar()

    File.write(caminho_arquivo, dados)
  end

  def decodificar(string) do
    string
    |> String.split("\n")
    |> Enum.filter(fn string -> "" != String.trim(string) end)
    |> Enum.map(fn string -> String.split(string, ",") end)
    |> Enum.map(fn [descricao, estado] -> {descricao, estado} end)
  end

  def processar(tarefas, []) do
    tarefas
    |> Enum.reject(&completada?/1)
    |> Enum.each(&imprimir/1)

    tarefas
  end

  def processar(tarefas, ["todas"]) do
    Enum.each(tarefas, &imprimir/1)

    tarefas
  end

  defp completada?({_descricao, estado}) do
    estado == "completada"
  end

  defp imprimir({descricao, _estado}) do
    IO.puts(descricao)
  end

  def codificar(tarefas) do
    tarefas
    |> Enum.map(fn {descricao, estado} -> [descricao, estado] end)
    |> Enum.map(fn lista -> Enum.join(lista, ",") end)
    |> Enum.concat([""])
    |> Enum.join("\n")
  end
end
