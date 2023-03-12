defmodule TarefasWeb.ControladorTarefas do
  @moduledoc """
  Módulo para a interface web do aplicativo
  """
  use TarefasWeb, :controller

  alias Tarefas.Tarefa

  @uuid Application.compile_env(:tarefas, :uuid)

  def listar(conn, _parametro) do json(conn, tarefas()) end

  def inserir(conn, %{"descricao" => desc}) do
    nova_tarefa = %Tarefa{id: @uuid.(), descricao: desc}

    tarefas()
      |> Tarefas.inserir(nova_tarefa)
      |> Tarefas.salvar()
    json(conn, nova_tarefa)
  end

  def mover(conn, %{"origem" => origem, "destino" => destino}) do
    tarefas()
      |>Tarefas.mover(to_int(origem), to_int(destino))
      |>Tarefas.salvar()
    json(conn, "")
  end

  def remover(conn, %{"posicao" => posicao}) do
    tarefas()
      |> Tarefas.remover(to_int(posicao))
      |> Tarefas.salvar()
    json(conn, "")
  end

  def completar(conn, %{"posicao" => posicao}) do
    tarefas()
      |> Tarefas.completar(to_int(posicao))
      |> Tarefas.salvar()
    json(conn, "")
  end

  def reiniciar(conn, %{"posicao" => posicao}) do
    tarefas()
      |> Tarefas.reiniciar(posicao)
      |> Tarefas.salvar()
    json(conn, "")
  end

  defp tarefas() do Tarefas.ler() end
  defp to_int(str) do String.to_integer(str) end
end
