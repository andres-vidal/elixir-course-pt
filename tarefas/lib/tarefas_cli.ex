defmodule Tarefas.CLI do
  def main(args) do
    caminho_arquivo = Path.join(File.cwd!(), "tarefas.txt")

    dados = File.read!(caminho_arquivo)
    |> decodificar
    |> processar(args)
    |> codificar

    File.write(caminho_arquivo, dados)
  end

  def decodificar(string) do
    string
    |> String.split("\n")
    |> Enum.filter(fn string -> "" != String.trim(string) end)
    |> Enum.map(fn string -> String.split(string, ", ") end)
    |> Enum.map(fn [description, state] -> {description, state} end)
  end

  def processar(tarefas, []) do
    tarefas
    |> Enum.reject(&completada?/1)
    |> Enum.map(&imprime/1)
    tarefas
  end

  def processar(tarefas, ["todas"]) do
    processar(tarefas, [])
    IO.puts("")
    IO.puts("Tarefas completadas!")
    tarefas
    |> Enum.filter(&completada?/1)
    |> Enum.each(&imprime/1)
    tarefas
  end

  def processar(tarefas, [descricao_nova_tarefa]) do
    tarefas ++ [{descricao_nova_tarefa, "sem_completar"}]
  end

  def processar(tarefas, ["completar", pos]) do
    {pos, _} = Integer.parse(pos)
    pos = pos - 1
    {descricao, _estado} = Enum.at(tarefas, pos)
    tarefas
    |> List.replace_at(pos, {descricao, "completada"})
  end

  def processar(tarefas, ["remover", pos]) do
    {pos, _} = Integer.parse(pos)
    pos = pos - 1
    tarefas
    |> List.delete_at(pos)
  end

  def processar(tarefas, [descricao_nova_tarefa, pos]) do
    {pos, _} = Integer.parse(pos)
    pos = pos - 1
    tarefas
    |> List.insert_at(pos, {descricao_nova_tarefa, "sem_completar"})
  end

  def processar(tarefas, ["mover", pos_velha, pos_nova]) do
    [{pos_nova, _} | {pos_velha, _}] = [Integer.parse(pos_nova) | Integer.parse(pos_velha)]
    pos_velha = pos_velha - 1
    pos_nova = pos_nova - 1
    tarefa = Enum.at(tarefas, pos_velha)

    tarefas
    |> List.delete_at(pos_velha)
    |> List.insert_at(pos_nova, tarefa)
  end

  def processar(tarefas, ["trocar", pos_velha, pos_nova]) do
    [{pos_nova, _} | {pos_velha, _}] = [Integer.parse(pos_nova) | Integer.parse(pos_velha)]
    pos_velha = pos_velha - 1
    pos_nova = pos_nova - 1
    antiga_tarefa = Enum.at(tarefas, pos_velha)
    nova_tarefa = Enum.at(tarefas, pos_nova)

    tarefas
    |> List.replace_at(pos_velha, nova_tarefa)
    |> List.replace_at(pos_nova, antiga_tarefa)
  end

  def codificar(tarefas) do
    tarefas
    |> Enum.map(fn {description, state} -> [description, state] end)
    |> Enum.map(fn lista -> Enum.join(lista, ", ") end)
    |> Kernel.++([""])
    |> Enum.join("\n")
  end


  defp completada?({_descricao, estado}) do
    estado == "completada"
  end

  defp imprime({descricao, _estado}) do
    IO.puts(descricao)
  end

end
