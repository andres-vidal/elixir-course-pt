defmodule Tarefas.Test do
  @moduledoc """
  Testes para o módulo Tarefas
  """
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Tarefas

  alias Tarefas.Tarefa

  setup do
    File.rm_rf!(Tarefas.caminho_arquivo())
    on_exit(fn -> File.rm_rf!(Tarefas.caminho_arquivo()) end)
    []
  end

  @tarefas_structs [
    %Tarefa{id: "a", descricao: "Tarefa 1"},
    %Tarefa{id: "b", descricao: "Tarefa 2"},
    %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
  ]

  @tarefas_string """
  a,Tarefa 1,sem_completar
  b,Tarefa 2,sem_completar
  c,Tarefa 3,completada
  """

  describe "decodificar/1" do
    test "converte um string em uma lista de tarefas" do
      assert @tarefas_structs == Tarefas.decodificar(@tarefas_string)
    end
  end

  describe "codificar/1" do
    test "converte uma lista de tarefas em string" do
      assert @tarefas_string == Tarefas.codificar(@tarefas_structs)
    end
  end

  describe "filtrar/1" do
    test "quando completadas? for verdadeiro, retorna únicamente as tarefas completadas" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3"},
        %Tarefa{id: "d", descricao: "Tarefa 4", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.filtrar(entrada, completadas?: true)
    end

    test "quando completadas? for falso, retorna únicamente as tarefas completadas" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3"},
        %Tarefa{id: "d", descricao: "Tarefa 4", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.filtrar(entrada, completadas?: false)
    end
  end

  describe "ordernar/1" do
    test "quando todas as tarefas estão sem completar, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert tarefas == Tarefas.ordenar(tarefas)
    end

    test "quando todas as tarefas estão completadas, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert tarefas == Tarefas.ordenar(tarefas)
    end

    test "quando as tarefas completadas estão no final, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"},
        %Tarefa{id: "d", descricao: "Tarefa 4", estado: "completada"},
        %Tarefa{id: "e", descricao: "Tarefa 5", estado: "completada"},
        %Tarefa{id: "f", descricao: "Tarefa 6", estado: "completada"}
      ]

      assert tarefas == Tarefas.ordenar(tarefas)
    end

    test "quando as tarefas completadas não estão no final, retorna a lista com as tarefas completadas no final e a mesma ordem relativa" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3"},
        %Tarefa{id: "d", descricao: "Tarefa 4", estado: "completada"},
        %Tarefa{id: "e", descricao: "Tarefa 5"},
        %Tarefa{id: "f", descricao: "Tarefa 6", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3"},
        %Tarefa{id: "e", descricao: "Tarefa 5"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4", estado: "completada"},
        %Tarefa{id: "f", descricao: "Tarefa 6", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.ordenar(entrada)
    end
  end

  describe "imprimir/1" do
    test "imprime as descrições das tarefas em linhas separadas" do
      saida_esperada = """
      Tarefa 1
      Tarefa 2
      Tarefa 3
      """

      assert saida_esperada == capture_io(fn -> Tarefas.imprimir(@tarefas_structs) end)
    end
  end

  describe "inserir/2" do
    test "numa lista vazia, insere a Tarefa" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      assert [nova_tarefa] == Tarefas.inserir([], nova_tarefa)
    end

    test "numa lista não vazia, insere a Tarefa no final da lista" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        nova_tarefa
      ]

      assert saida_esperada == Tarefas.inserir(@tarefas_structs, nova_tarefa)
    end
  end

  describe "inserir/3" do
    test "insere uma Tarefa no começo da lista quando a posição é 0" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        nova_tarefa,
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.inserir(@tarefas_structs, nova_tarefa, 0)
    end

    test "insere uma Tarefa no começo da lista quando a posição é negativa" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        nova_tarefa,
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.inserir(@tarefas_structs, nova_tarefa, -1)
    end

    test "insere uma Tarefa no meio da lista" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        nova_tarefa,
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.inserir(@tarefas_structs, nova_tarefa, 2)
    end

    test "insere uma Tarefa exatamente no final da lista" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        nova_tarefa
      ]

      assert saida_esperada == Tarefas.inserir(@tarefas_structs, nova_tarefa, 3)
    end

    test "insere uma Tarefa exatamente no final da lista quando uma posição do que o tamanho da lista é passado" do
      nova_tarefa = %Tarefa{descricao: "Tarefa 4", estado: "sem_completar"}

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        nova_tarefa
      ]

      assert saida_esperada == Tarefas.inserir(@tarefas_structs, nova_tarefa, 10)
    end
  end

  describe "mover/3 quando origem < destino" do
    test "move a primeira tarefa quando origem é negativo" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, -1, 2)
    end

    test "move a primeira tarefa exatamente ao final da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "a", descricao: "Tarefa 1"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 0, 3)
    end

    test "move a primeira tarefa ao final da lista quando destino é maior que o tamanho da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "a", descricao: "Tarefa 1"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 0, 10)
    end

    test "move a primeira tarefa ao meio da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 0, 1)
    end

    test "move uma tarefa do meio exatamente ao final da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "b", descricao: "Tarefa 2"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 1, 3)
    end

    test "move uma tarefa do meio ao final da lista quando destino é maior que o tamanho da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "b", descricao: "Tarefa 2"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 1, 10)
    end

    test "move uma tarefa do meio ao meio da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 1, 2)
    end
  end

  describe "mover/3 quando origem > destino" do
    test "move a ultima tarefa quando o origem está além do tamanho da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 10, 1)
    end

    test "move a ultima tarefa exatamente ao começo da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 3, 0)
    end

    test "move a ultima tarefa ao começo da lista quando destino é maior que o tamanho da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 3, -1)
    end

    test "move a ultima tarefa ao meio da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "d", descricao: "Tarefa 4"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 3, 1)
    end

    test "move uma tarefa do meio exatamente ao começo da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 2, 0)
    end

    test "move uma tarefa do meio ao começo da lista quando destino é negativo" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 2, -1)
    end

    test "move uma tarefa do meio ao meio da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert saida_esperada == Tarefas.mover(entrada, 2, 1)
    end
  end

  describe "mover/3 quando origem == destino" do
    test "com posição negativa" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert tarefas == Tarefas.mover(tarefas, -1, -1)
    end

    test "no começo da lista, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert tarefas == Tarefas.mover(tarefas, 0, 0)
    end

    test "no meio da lista, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert tarefas == Tarefas.mover(tarefas, 2, 2)
    end

    test "no final da lista, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert tarefas == Tarefas.mover(tarefas, 3, 3)
    end

    test "além do final da lista, retorna a mesma lista" do
      tarefas = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "d", descricao: "Tarefa 4"}
      ]

      assert tarefas == Tarefas.mover(tarefas, 10, 10)
    end
  end

  describe "remover/2" do
    test "remove a primeira tarefa quando a posição é 0" do
      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.remover(@tarefas_structs, 0)
    end

    test "remove a primeira tarefa quando a posição é negativa" do
      saida_esperada = [
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.remover(@tarefas_structs, -1)
    end

    test "remove a tarefa do meio" do
      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.remover(@tarefas_structs, 1)
    end

    test "remove a última tarefa quando a posição exata é passada" do
      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"}
      ]

      assert saida_esperada == Tarefas.remover(@tarefas_structs, 2)
    end

    test "remove a última tarefa quando a posição passada é maior que o tamanho da lista" do
      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"}
      ]

      assert saida_esperada == Tarefas.remover(@tarefas_structs, 10)
    end
  end

  describe "completar/2" do
    test "marca como completada a primeira tarefa quando a posição passada é 0" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.completar(entrada, 0)
    end

    test "marca como completada a primeira tarefa quando a posição passada é negativa" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.completar(entrada, -1)
    end

    test "marca como completada a tarefa do meio" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.completar(entrada, 1)
    end

    test "marca como completada a tarefa do final quando a posição passada é exata" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.completar(entrada, 2)
    end

    test "marca como completada a tarefa do final quando a posição passada é maior que o tamanho da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.completar(entrada, 10)
    end
  end

  describe "reiniciar/2" do
    test "marca como completada a primeira tarefa quando a posição passada é 0" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.reiniciar(entrada, 0)
    end

    test "marca como completada a primeira tarefa quando a posição passada é negativa" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.reiniciar(entrada, -1)
    end

    test "marca como completada a tarefa do meio" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      assert saida_esperada == Tarefas.reiniciar(entrada, 1)
    end

    test "marca como completada a tarefa do final quando a posição passada é exata" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.reiniciar(entrada, 2)
    end

    test "marca como completada a tarefa do final quando a posição passada é maior que o tamanho da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"}
      ]

      saida_esperada = [
        %Tarefa{id: "a", descricao: "Tarefa 1", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2", estado: "completada"},
        %Tarefa{id: "c", descricao: "Tarefa 3"}
      ]

      assert saida_esperada == Tarefas.reiniciar(entrada, 10)
    end
  end

  describe "ler/0" do
    test "quando o arquivo de tarefas não existe, o cria e retorna uma lista vazia" do
      assert [] = Tarefas.ler()
      assert File.exists?(Tarefas.caminho_arquivo())
    end

    test "quando o arquivo de tarefas existe e é vazio, retorna uma lista vazia" do
      File.write!(Tarefas.caminho_arquivo(), "")

      assert [] = Tarefas.ler()
    end

    test "quando o arquivo de tarefas existe e não é vazio, retorna uma lista de tarefas com os conteúdos do arquivo" do
      File.write!(Tarefas.caminho_arquivo(), @tarefas_string)

      assert @tarefas_structs = Tarefas.ler()
    end
  end

  describe "salvar/1" do
    test "quando o arquivo de tarefas não existe, o cria e salva a lista de tarefas" do
      Tarefas.salvar(@tarefas_structs)

      assert {:ok, @tarefas_string} == File.read(Tarefas.caminho_arquivo())
    end

    test "quando o arquivo de tarefas existe, salva a lista de tarefas sobreescrevendo os valores existentes" do
      File.write!(Tarefas.caminho_arquivo(), "Lorem ipsum dolor sit amet")

      Tarefas.salvar(@tarefas_structs)

      assert {:ok, @tarefas_string} == File.read(Tarefas.caminho_arquivo())
    end

    test "salva as tarefas completadas no final da lista" do
      entrada = [
        %Tarefa{id: "a", descricao: "Tarefa 1"},
        %Tarefa{id: "c", descricao: "Tarefa 3", estado: "completada"},
        %Tarefa{id: "b", descricao: "Tarefa 2"}
      ]

      saida_esperada = """
      a,Tarefa 1,sem_completar
      b,Tarefa 2,sem_completar
      c,Tarefa 3,completada
      """

      File.write!(Tarefas.caminho_arquivo(), "Lorem ipsum dolor sit amet")

      Tarefas.salvar(entrada)

      assert {:ok, saida_esperada} == File.read(Tarefas.caminho_arquivo())
    end
  end
end
