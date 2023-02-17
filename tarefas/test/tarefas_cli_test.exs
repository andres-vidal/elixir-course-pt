defmodule Tarefas.CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Tarefas.CLI

  describe "decodificar/1" do
    test "converte um string em uma lista de tarefas" do
      entrada = """
      Tarefa 1,sem_completar
      Tarefa 2,sem_completar
      Tarefa 3,completada
      """

      saida_esperada = [
        {"Tarefa 1", "sem_completar"},
        {"Tarefa 2", "sem_completar"},
        {"Tarefa 3", "completada"}
      ]

      assert saida_esperada == Tarefas.CLI.decodificar(entrada)
    end
  end

  describe "codificar/1" do
    test "converte uma lista de tarefas em string" do
      entrada = [
        {"Tarefa 1", "sem_completar"},
        {"Tarefa 2", "sem_completar"},
        {"Tarefa 3", "completada"}
      ]

      saida_esperada = """
      Tarefa 1,sem_completar
      Tarefa 2,sem_completar
      Tarefa 3,completada
      """

      assert saida_esperada == Tarefas.CLI.codificar(entrada)
    end
  end

  describe "processar/2" do
    test "quando o segundo argumento é vazio, imprime as tarefas fornecidas que foram completadas" do
      entrada = [
        {"Tarefa 1", "sem_completar"},
        {"Tarefa 2", "sem_completar"},
        {"Tarefa 3", "completada"}
      ]

      saida_esperada = """
      Tarefa 1
      Tarefa 2
      """

      assert saida_esperada == capture_io(fn -> Tarefas.CLI.processar(entrada, []) end)
    end

    test "quando o segundo argumento é [\"todas\"], imprime as tarefas fornecidas" do
      entrada = [
        {"Tarefa 1", "sem_completar"},
        {"Tarefa 2", "sem_completar"},
        {"Tarefa 3", "completada"}
      ]

      saida_esperada = """
      Tarefa 1
      Tarefa 2

      -- Tarefas Completadas --
      Tarefa 3
      """

      assert saida_esperada == capture_io(fn -> Tarefas.CLI.processar(entrada, ["todas"]) end)
    end

    test "quando o segundo argumento é um string qualquer, adiciona uma tarefa à lista de tarefas" do
      descricao_da_nova_tarefa = "Tarefa 4"

      entrada = [
        {"Tarefa 1", "sem_completar"},
        {"Tarefa 2", "sem_completar"},
        {"Tarefa 3", "completada"}
      ]

      saida_esperada = [
        {"Tarefa 1", "sem_completar"},
        {"Tarefa 2", "sem_completar"},
        {"Tarefa 3", "completada"},
        {descricao_da_nova_tarefa, "sem_completar"}
      ]

      assert saida_esperada == Tarefas.CLI.processar(entrada, [descricao_da_nova_tarefa])
    end
  end
end
