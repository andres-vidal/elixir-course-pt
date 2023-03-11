defmodule Tarefas.CLI do
  @moduledoc """
  Módulo para a interface de linha de comandos do aplicativo
  """

  @uuid Application.compile_env(:tarefas, :uuid)

  alias Tarefas.Tarefa, as: Tarefa

  @doc """
  Ponto de entrada do aplicativo por linha de comandos.

  Recebe os comandos passados na linha de comandos como uma lista de strings.

  Lê o arquivo de tarefas, processa as tarefas segundo os comandos recebidos e salva o resultado.
  """
  def main(comandos) do
    Tarefas.ler()
    |> Tarefas.CLI.processar(comandos)
    |> Tarefas.salvar()
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma lista de comandos

  Processa a lista segundo os comandos recebidos

  Retorna o resultado do processamento
  """

  def processar(tarefas, []) when is_list(tarefas) do
    tarefas
    |> Enum.reject(&Tarefa.completada?/1)
    |> Enum.each(&Tarefa.imprimir/1)
  end

  def processar(tarefas, ["todas"]) when is_list(tarefas) do
    processar(tarefas, [])
    IO.puts("\n-- Tarefas Completadas --")
    tarefas
    |> Enum.filter(&Tarefa.completada?/1)
    |> Enum.each(&Tarefa.imprimir/1)
  end

  def processar(tarefas, ["remover", posicao]) when is_list(tarefas) do
    posicao = String.to_integer(posicao)
    tarefas
    |> List.delete_at(posicao)
  end

  def processar(tarefas, ["reiniciar", posicao]) when is_list(tarefas) do
    posicao = String.to_integer(posicao)
    tarefa = Enum.at(tarefas, posicao)
    tarefa = Tarefa.reiniciar(tarefa)
    tarefas |> List.replace_at(posicao, tarefa)
  end

  def processar(tarefas, ["completar", posicao]) when is_list(tarefas) do
    posicao = String.to_integer(posicao)
    tarefa = Enum.at(tarefas, posicao)
    tarefa = Tarefa.completar(tarefa)
    tarefas |> List.replace_at(posicao, tarefa)
  end

  def processar(tarefas, [descricao, "0"]) when is_list(tarefas) do
    nova_tarefa = %Tarefa{descricao: descricao, id: @uuid.()}
    [nova_tarefa] ++ tarefas
  end

  def processar(tarefas, [descricao]) when is_list(tarefas) do
    nova_tarefa = %Tarefa{descricao: descricao, id: @uuid.()}
    tarefas ++ [nova_tarefa]
  end

  def processar(tarefas, ["mover", origem, destino]) when is_list(tarefas) do
    origem = String.to_integer(origem)
    destino = String.to_integer(destino)
    tarefa = Enum.at(tarefas, origem)
    tarefas
    |> List.delete_at(origem)
    |> List.insert_at(destino, tarefa)
  end

  def processar(tarefas, [descricao, posicao]) when is_list(tarefas) do
    posicao = String.to_integer(posicao)
    nova_tarefa = %Tarefa{descricao: descricao}
    tarefas
    |> List.insert_at(posicao, nova_tarefa)
  end

  end
