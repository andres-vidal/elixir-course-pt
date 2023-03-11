defmodule Tarefas.CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Tarefas.CLI

  describe "decodificar/1" do
    test "converte um string em uma lista de tarefas" do

      input = """
              Tarefa 1, sem_completar
              Tarefa 2, sem_completar
              Tarefa 3, completada

              """

      expected_output = [{"Tarefa 1", "sem_completar"},
                         {"Tarefa 2", "sem_completar"},
                        {"Tarefa 3", "completada"}]

      assert Tarefas.CLI.decodificar(input) == expected_output
    end
  end

  describe "codificar/1" do

    test "converte uma lista de tarefas devolta pra uma string" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = """
              Tarefa 1, sem_completar
              Tarefa 2, sem_completar
              Tarefa 3, completada
              """

      assert Tarefas.CLI.codificar(input) == expected_output
    end
  end

  describe "processar/2" do

    test "lista tarefas nao completadas quando primeiro arg vazio" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = """
              Tarefa 1
              Tarefa 2
              """

      assert capture_io(fn -> Tarefas.CLI.processar(input, []) end) == expected_output
    end

    test "lista todas as tarefas quanto primeiro arg == todas" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = """
              Tarefa 1
              Tarefa 2

              Tarefas completadas!
              Tarefa 3
              """

      assert capture_io(fn -> Tarefas.CLI.processar(input, ["todas"]) end) == expected_output
    end

    test "adiciona nova tarefa com a descrição escrita" do
      nova_descricao = "Tarefa 4"
      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = [{"Tarefa 1", "sem_completar"},
                        {"Tarefa 2", "sem_completar"},
                        {"Tarefa 3", "completada"},
                        {nova_descricao, "sem_completar"}]

      assert Tarefas.CLI.processar(input, [nova_descricao]) == expected_output
    end

    test "remove a tarefa na posição indicada quando o primeiro arg é remover" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = [{"Tarefa 1", "sem_completar"},
                        {"Tarefa 2", "sem_completar"}]

      assert Tarefas.CLI.processar(input, ["remover", "3"]) == expected_output
    end

    test "adiciona a tarefa na posição indicada quando o segundo arg é um numero" do
      nova_tarefa = "mover"
      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = [{"Tarefa 1", "sem_completar"},
                        {nova_tarefa, "sem_completar"},
                        {"Tarefa 3", "completada"}]

      assert Tarefas.CLI.processar(input, [nova_tarefa, "2"]) == expected_output
    end

    test "move a tarefa na posição indicada quando o primeiro arg é mover" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = [{"Tarefa 2", "sem_completar"},
                        {"Tarefa 3", "completada"},
                        {"Tarefa 1", "sem_completar"}]

      assert Tarefas.CLI.processar(input, ["mover", "1", "3"]) == expected_output
    end

    test "troca as tarefas de posição" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "sem_completar"},
              {"Tarefa 3", "completada"}]

      expected_output = [{"Tarefa 3", "completada"},
                        {"Tarefa 2", "sem_completar"},
                        {"Tarefa 1", "sem_completar"}]

      assert Tarefas.CLI.processar(input, ["trocar", "3", "1"]) == expected_output
    end

    test "completa a tarefa na posicao indicada" do

      input = [{"Tarefa 1", "sem_completar"},
              {"Tarefa 2", "completada"},
              {"Tarefa 3", "sem_completar"}]

      expected_output = [{"Tarefa 1", "completada"},
                        {"Tarefa 2", "completada"},
                        {"Tarefa 3", "sem_completar"}]

      assert Tarefas.CLI.processar(input, ["completar", "1"]) == expected_output
    end
  end
end
