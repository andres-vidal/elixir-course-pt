defmodule TarefasWeb.ControladorTarefas do
  @moduledoc """
  Módulo para a interface web do aplicativo
  """
  use TarefasWeb, :controller
  alias Tarefas.Tarefa, as: Tarefa
  alias Tarefas

  @uuid Application.compile_env(:tarefas, :uuid)

  defp tarefas do Tarefas.ler() end

  def listar(conn, _params) do
    json(conn, Tarefas.ler())
  end

  def inserir(conn, %{"descricao" => descricao}) do
    tarefa = %Tarefa{id: @uuid.(), descricao: descricao, estado: "sem_completar"}
    tarefas()
    |> Tarefas.inserir(tarefa)
    |> Tarefas.salvar()
    json(conn, tarefa)
  end

  def mover(conn, %{"origem" => origem, "destino" => destino}) do
    origem = String.to_integer(origem)
    destino = String.to_integer(destino)
    tarefas()
    |> Tarefas.mover(origem, destino)
    |> Tarefas.salvar()
    json(conn, "")
  end

  def remover(conn, %{"posicao" => posicao}) do
    posicao = String.to_integer(posicao)
    tarefas()
    |> Tarefas.remover(posicao)
    |> Tarefas.salvar()
    json(conn, "")
  end

  def completar(conn, %{"posicao" => posicao}) do
    posicao = String.to_integer(posicao)
    tarefas()
    |> Tarefas.completar(posicao)
    |> Tarefas.salvar()
    json(conn, "")
  end

  def reiniciar(conn, %{"posicao" => posicao}) do
    posicao = String.to_integer(posicao)
    tarefas()
    |> Tarefas.reiniciar(posicao)
    |> Tarefas.salvar()
    json(conn, "")
  end
end
