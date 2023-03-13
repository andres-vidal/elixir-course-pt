defmodule TarefasWeb.ControladorTarefasTest do
  @moduledoc """
  Testes para o módulo ControladorTarefas
  """
  use TarefasWeb.ConnCase

  setup do
    File.write(Tarefas.caminho_arquivo(), "")
    on_exit(fn -> File.rm_rf!(Tarefas.caminho_arquivo()) end)
    []
  end

  describe "GET /tarefas" do
    test "quando a lista de tarefas é vazia, retorna uma lista vazia", %{conn: conn} do
      path = Routes.controlador_tarefas_path(conn, :listar)
      conn = get(conn, path)

      assert [] == json_response(conn, 200)
      assert "" == File.read!(Tarefas.caminho_arquivo())
    end

    test "quando a lista de tarefas não é vazia, retorna a lista de tarefas", %{conn: conn} do
      entrada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,completada
      """

      saida_esperada = [
        %{"id" => "a", "descricao" => "Tarefa 1", "estado" => "sem_completar"},
        %{"id" => "b", "descricao" => "Tarefa 2", "estado" => "sem_completar"},
        %{"id" => "c", "descricao" => "Tarefa 3", "estado" => "completada"}
      ]

      File.write(Tarefas.caminho_arquivo(), entrada_arquivo)

      path = Routes.controlador_tarefas_path(conn, :listar)
      conn = get(conn, path)

      assert saida_esperada == json_response(conn, 200)
      assert entrada_arquivo == File.read!(Tarefas.caminho_arquivo())
    end
  end

  # describe "POST /tarefas/:descricao" do
  #   test "quando a lista de tarefas é vazia", %{conn: conn} do
  #     entrada = %{"descricao" => "Tarefa 1"}

  #     saida_esperada = %{
  #       "id" => "",
  #       "descricao" => "Tarefa 1",
  #       "estado" => "sem_completar"
  #     }

  #     saida_esperda_arquivo = """
  #     ,Tarefa 1,sem_completar
  #     """

  #     path = Routes.controlador_tarefas_path(conn, :inserir)

  #     conn =
  #       conn
  #       |> put_req_header("content-type", "application/json")
  #       |> post(path, entrada)

  #     assert saida_esperada == json_response(conn, 200)
  #     assert saida_esperda_arquivo == File.read!(Tarefas.caminho_arquivo())
  #   end

  #   test "quando a lista de tarefas não é vazia", %{conn: conn} do
  #     entrada = %{"descricao" => "Tarefa 1"}

  #     saida_esperada = %{
  #       "id" => "",
  #       "descricao" => "Tarefa 1",
  #       "estado" => "sem_completar"
  #     }

  #     entrada_arquivo = """
  #     a,Tarefa 1,sem_completar
  #     b,Tarefa 2,sem_completar
  #     """

  #     saida_esperda_arquivo = """
  #     a,Tarefa 1,sem_completar
  #     b,Tarefa 2,sem_completar
  #     ,Tarefa 1,sem_completar
  #     """

  #     File.write(Tarefas.caminho_arquivo(), entrada_arquivo)

  #     path = Routes.controlador_tarefas_path(conn, :inserir)

  #     conn =
  #       conn
  #       |> put_req_header("content-type", "application/json")
  #       |> post(path, entrada)

  #     assert saida_esperada == json_response(conn, 200)
  #     assert saida_esperda_arquivo == File.read!(Tarefas.caminho_arquivo())
  #   end
  # end

  describe "POST /tarefas/:origem/mover-a/:destino" do
    test "move a tarefa da posição origem à posição destino", %{conn: conn} do
      entrada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,completada
      """

      saida_esperada_arquivo = """
      b,Tarefa 2,sem_completar
      a,Tarefa 1,sem_completar
      c,Tarefa 3,completada
      """

      File.write(Tarefas.caminho_arquivo(), entrada_arquivo)

      path = Routes.controlador_tarefas_path(conn, :mover, 0, 1)
      conn = post(conn, path)

      assert "" == json_response(conn, 200)
      assert saida_esperada_arquivo == File.read!(Tarefas.caminho_arquivo())
    end
  end

  describe "DELETE /tarefas/:posicao" do
    test "remove a tarefa da posição fornecida da lista de tarefas", %{conn: conn} do
      entrada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,completada
      """

      saida_esperada_arquivo = """
      a,Tarefa 1,sem_completar
      c,Tarefa 3,completada
      """

      File.write(Tarefas.caminho_arquivo(), entrada_arquivo)

      path = Routes.controlador_tarefas_path(conn, :remover, 1)
      conn = delete(conn, path)

      assert "" == json_response(conn, 200)
      assert saida_esperada_arquivo == File.read!(Tarefas.caminho_arquivo())
    end
  end

  describe "POST /tarefas/completadas/:posicao" do
    test "marca a tarefa da posição fornecida como completada", %{conn: conn} do
      entrada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,completada
      """

      saida_esperada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,completada
      c,Tarefa 3,completada
      """

      File.write(Tarefas.caminho_arquivo(), entrada_arquivo)

      path = Routes.controlador_tarefas_path(conn, :completar, 1)
      conn = post(conn, path)

      assert "" == json_response(conn, 200)
      assert saida_esperada_arquivo == File.read!(Tarefas.caminho_arquivo())
    end
  end

  describe "DELETE /tarefas/completadas/:posicao" do
    test "marca a tarefa da posição fornecida como sem completar", %{conn: conn} do
      entrada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,completada
      """

      saida_esperada_arquivo = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,sem_completar
      """

      File.write(Tarefas.caminho_arquivo(), entrada_arquivo)

      path = Routes.controlador_tarefas_path(conn, :reiniciar, 2)
      conn = delete(conn, path)

      assert "" == json_response(conn, 200)
      assert saida_esperada_arquivo == File.read!(Tarefas.caminho_arquivo())
    end
  end
end
