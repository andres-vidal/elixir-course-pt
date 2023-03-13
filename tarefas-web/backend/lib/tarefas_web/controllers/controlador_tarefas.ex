defmodule TarefasWeb.ControladorTarefas do
  @moduledoc """
  Módulo para a interface web do aplicativo
  """
  use TarefasWeb, :controller

  alias Tarefas.Tarefa

  @uuid Application.compile_env(:tarefas, :uuid)


  def listar(conn,params) do
    tarefas=Tarefas.tarefas
    json(conn,Tarefas.CLI.processar(tarefas,"todas"))
  end

  def completar(conn,params) do
    %{"posicao" => posicao} = params
    Tarefas.CLI.main(["completar",posicao])
    json(conn,"")
  end

  def inserir(conn,%{"descricao" => descricao,"posicao" => posicao})when descricao !== "completadas" do
    Tarefas.CLI.main([descricao,posicao])
    json(conn,"")
  end

  def inserir(conn,%{"descricao" => descricao})do
    Tarefas.CLI.main([descricao])
    json(conn,"")
  end

  def mover(conn,params) do
    %{"origem" => origem,"destino" => destino} = params
   Tarefas.CLI.main(["mover",origem,destino])
   json(conn,"")
  end

  def remover(conn,params) do
    %{"posicao" => posicao} = params
   Tarefas.CLI.main(["remover",posicao])
   json(conn,"")
  end

  def reiniciar(conn,params) do
    %{"posicao" => posicao} = params
    Tarefas.CLI.main(["reiniciar",posicao])
    json(conn,"")
  end
end
