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

  def processar(tarefas, _comandos) when is_list(tarefas) do
    IO.puts("Comando não implementado.")
  end
end
