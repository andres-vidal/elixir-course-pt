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
    test "quando o segundo argumento é vazio, imprime as tarefas fornecidas" do
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
      Tarefa 3
      """

      assert saida_esperada == capture_io(fn -> Tarefas.CLI.processar(entrada, ["todas"]) end)
    end
  end
end
