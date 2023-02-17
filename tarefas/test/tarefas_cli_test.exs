defmodule Tarefas.CLITest do
  use ExUnit.Case
  doctest Tarefas.CLI

  describe "analisar/1" do
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

      assert saida_esperada == Tarefas.CLI.analisar(entrada)
    end
  end

  describe "codificar/1" do
    test "converte um string em uma lista de tarefas" do
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
end
