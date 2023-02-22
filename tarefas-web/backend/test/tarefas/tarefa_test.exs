defmodule TarefaTest do
  @moduledoc """
  Testes para o módulo Tarefa
  """
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Tarefas.Tarefa

  alias Tarefas.Tarefa

  describe "struct" do
    test "quando o estado não for especificado, a Tarefa é criada com estado sem_completar" do
      tarefa = %Tarefa{
        id: "id",
        descricao: "Descrição"
      }

      assert "sem_completar" = tarefa.estado
    end
  end

  describe "completar/1" do
    test "quando recebe uma Tarefa sem completar, retorna uma Tarefa com o mesmo conteúdo, mas completada" do
      entrada = %Tarefa{
        id: "id",
        descricao: "Descrição"
      }

      saida_esperada = %Tarefa{
        id: "id",
        descricao: "Descrição",
        estado: "completada"
      }

      assert saida_esperada == Tarefa.completar(entrada)
    end

    test "quando recebe uma Tarefa completada, retorna uma Tarefa igual" do
      tarefa = %Tarefa{
        id: "id",
        descricao: "Descrição",
        estado: "completada"
      }

      assert tarefa == Tarefa.completar(tarefa)
    end
  end

  describe "reiniciar/1" do
    test "quando recebe uma Tarefa completada, retorna uma Tarefa com o mesmo conteúdo, mas sem completar" do
      entrada = %Tarefa{
        id: "id",
        descricao: "Descrição",
        estado: "completada"
      }

      saida_esperada = %Tarefa{
        id: "id",
        descricao: "Descrição"
      }

      assert saida_esperada == Tarefa.reiniciar(entrada)
    end

    test "quando recebe uma Tarefa sem completar, retorna uma Tarefa igual" do
      tarefa = %Tarefa{
        id: "id",
        descricao: "Descrição"
      }

      assert tarefa == Tarefa.reiniciar(tarefa)
    end
  end

  describe "codificar/1" do
    test "codifica uma tarefa completada como uma string no formato id,descricao,estado" do
      tarefa = %Tarefa{
        id: "123",
        descricao: "Tarefa 1",
        estado: "completada"
      }

      assert "123,Tarefa 1,completada" == Tarefa.codificar(tarefa)
    end

    test "codifica uma tarefa sem completar como uma string no formato id,descricao,estado" do
      tarefa = %Tarefa{
        id: "def",
        descricao: "Tarefa 2"
      }

      assert "def,Tarefa 2,sem_completar" == Tarefa.codificar(tarefa)
    end
  end

  describe "decodificar/1" do
    test "decodifica uma string no formato id,descricao,estado como uma Tarefa" do
      tarefa = %Tarefa{id: "123", descricao: "Descrição", estado: "completada"}

      assert tarefa == Tarefa.decodificar("123,Descrição,completada")
    end
  end

  describe "imprimir/1" do
    test "imprime a descrição de uma Tarefa completada no console" do
      tarefa = %Tarefa{
        id: "123",
        descricao: "Tarefa 1",
        estado: "completada"
      }

      saida_esperada = """
      Tarefa 1
      """

      assert saida_esperada == capture_io(fn -> Tarefa.imprimir(tarefa) end)
    end

    test "imprime a descrição de uma Tarefa sem completar no console" do
      tarefa = %Tarefa{
        id: "123",
        descricao: "Tarefa 3"
      }

      saida_esperada = """
      Tarefa 3
      """

      assert saida_esperada == capture_io(fn -> Tarefa.imprimir(tarefa) end)
    end
  end
end
