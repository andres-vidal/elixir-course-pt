defmodule Tarefas.CLITest do
  @moduledoc """
  Testes para a interface de linha de comandos do aplicativo
  """
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Tarefas.CLI

  alias Tarefas.Tarefa

  @entrada [
    %Tarefa{descricao: "Tarefa 1"},
    %Tarefa{descricao: "Tarefa 2"},
    %Tarefa{descricao: "Tarefa 3", estado: "completada"}
  ]

  describe "processar/2" do
    test "quando o segundo argumento é vazio, imprime as tarefas fornecidas que foram completadas" do
      saida_esperada = """
      Tarefa 3
      """

      assert saida_esperada == capture_io(fn -> Tarefas.CLI.processar(@entrada, []) end)
    end

    test "quando o segundo argumento é [\"todas\"], imprime as tarefas fornecidas" do
      saida_esperada = """
      Tarefa 1
      Tarefa 2

      -- Tarefas Completadas --
      Tarefa 3
      """

      assert saida_esperada == capture_io(fn -> Tarefas.CLI.processar(@entrada,"todas") end)
    end

    test "quando o segundo argumento é um string qualquer, adiciona uma tarefa à lista de tarefas" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        %Tarefa{descricao: "Tarefa 1"},
        %Tarefa{descricao: "Tarefa 2"},
        %Tarefa{descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{descricao: "Nova"},
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, ["Nova"])
    end

    test "quando o segundo argumento é [descricao, 0], adiciona uma tarefa à lista de tarefas no começo da lista" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        nova_tarefa,
        %Tarefa{descricao: "Tarefa 1"},
        %Tarefa{descricao: "Tarefa 2"},
        %Tarefa{descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, [nova_tarefa.descricao, "0"])
    end

    test "quando o segundo argumento é [descricao, posicao], adiciona uma tarefa à lista de tarefas na posição indicada" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        %Tarefa{descricao: "Tarefa 1"},
        %Tarefa{descricao: "Tarefa 2"},
        nova_tarefa,
        %Tarefa{descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, [nova_tarefa.descricao, "2"])
    end

    test "quando o segundo argumento é [\"mover\", origem, destino], move a tarefa da posição origem à posição destino" do
      saida_esperada = [
        %Tarefa{descricao: "Tarefa 2"},
        %Tarefa{descricao: "Tarefa 1"},
        %Tarefa{descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, ["mover", "0", "1"])
    end

    test "quando o segundo argumento é [\"remover\", posicao], remove a tarefa na posição fornecida da lista" do
      saida_esperada = [
        %Tarefa{descricao: "Tarefa 2"},
        %Tarefa{descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, ["remover", "0"])
    end

    test "quando o segundo argumento é [\"completar\", posicao], marca a tarefa na posição fornecida como completada" do
      saida_esperada = [
        %Tarefa{descricao: "Tarefa 1"},
        %Tarefa{descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, ["completar", "1"])
    end

    test "quando o segundo argumento é [\"reiniciar\", posicao], marca a tarefa na posição fornecida como completada" do
      saida_esperada = [
        %Tarefa{descricao: "Tarefa 1"},
        %Tarefa{descricao: "Tarefa 2"},
        %Tarefa{descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(@entrada, ["reiniciar", "2"])
    end
  end
end
