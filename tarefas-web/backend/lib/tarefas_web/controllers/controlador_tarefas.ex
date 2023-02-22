defmodule TarefasWeb.ControladorTarefas do
  @moduledoc """
  Módulo para a interface web do aplicativo
  """
  use TarefasWeb, :controller

  alias Tarefas.Tarefa

  @uuid Application.compile_env(:tarefas, :uuid)

  def listar(_, _) do
  end

  def inserir(_, _) do
  end

  def mover(_, _) do
  end

  def remover(_, _) do
  end

  def completar(_, _) do
  end

  def reiniciar(_, _) do
  end
end
