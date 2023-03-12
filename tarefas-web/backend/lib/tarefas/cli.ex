defmodule Tarefas.CLI do
  @moduledoc """
  Módulo para a interface de linha de comandos do aplicativo
  """

  @uuid Application.compile_env(:tarefas, :uuid)

  alias Tarefas.Tarefa

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
      |> Tarefas.filtrar(completadas?: false)
      |> Tarefas.imprimir()
  end


  def processar(tarefas, ["todas"]) when is_list(tarefas) do
    processar(tarefas, [])
    IO.puts("")
    IO.puts("-- Tarefas Completadas --")

    tarefas
      |> Tarefas.filtrar(completadas?: true)
      |> Tarefas.imprimir()
  end

  def processar(tarefas, ["remover", posicao]) when is_list(tarefas) do
    Tarefas.remover(tarefas, String.to_integer(posicao))
  end

  def processar(tarefas, ["completar", posicao]) when is_list(tarefas) do
    Tarefas.completar(tarefas, String.to_integer(posicao))
  end

  def processar(tarefas, ["reiniciar", posicao]) when is_list(tarefas) do
    Tarefas.reiniciar(tarefas, String.to_integer(posicao))
  end

  def processar(tarefas, [tarefa_desc]) when is_list(tarefas) do
    nova_tarefa = %Tarefa{id: @uuid.(), descricao: tarefa_desc}
    tarefas ++ [nova_tarefa]
  end

  def processar(tarefas, [tarefa_desc, posicao]) when is_list(tarefas) do
    nova_tarefa = %Tarefa{id: @uuid.(), descricao: tarefa_desc}
    Tarefas.inserir(tarefas, nova_tarefa, String.to_integer(posicao))
  end

  def processar(tarefas, ["mover", origem, destino]) when is_list(tarefas) do
    Tarefas.mover(tarefas, String.to_integer(origem), String.to_integer(destino))
  end

end
