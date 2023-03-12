defmodule Tarefas do
  @moduledoc """
  Módulo com utilidades gerais para a manipulação de listas de tarefas e do arquivo de tarefas
  """

  alias Tarefas.Tarefa

  @doc """
  Retorna o caminho ao arquivo onde estão salvas as tarefas
  """
  def caminho_arquivo do
    Path.join(File.cwd!(), Application.get_env(:tarefas, :file))
  end

  @doc """
  Lê as tarefas do arquivo de tarefas e as decodifica

  Retorna uma lista de structs do tipo Tarefa
  """
  def ler() do
    File.write(caminho_arquivo(), "", [:append])

    caminho_arquivo()
    |> File.read!()
    |> decodificar()
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Codifica as tarefas e as salva no arquivo, reescrevendo todos seus conteúdos
  """
  def salvar(tarefas) when is_list(tarefas) do
    string =
      tarefas
      |> ordenar
      |> codificar

    File.write(caminho_arquivo(), string)
  end

  @doc """
  Recebe uma string no formato "descricao,estado" e o decodifica linha a linha

  Retorna uma lista de structs do tipo Tarefa com os conteúdos da string
  """
  def decodificar(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&Tarefa.decodificar/1)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Codifica a lista em uma string unindo as structs codificadas com quebras de linha. Adiciona uma linha vazia no final.

  Retorna a string codificada
  """

  def codificar(tarefas) when is_list(tarefas) do
    tarefas = tarefas
    |> Enum.map(&Tarefa.codificar/1)
    |> Enum.join("\n")
   tarefas <> "\n"
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e um booleano completadas?

  Se completadas? for verdadeiro, retorna os elementos com o estado "completada"
  Se completadas? for falso, retorna os elementos com o estado "sem_completar"
  """

  def filtrar(tarefas, completadas?: true) do
    Enum.filter(tarefas, &Tarefa.completada?(&1) == true)
  end

  def filtrar(tarefas, completadas?: false) do
    Enum.filter(tarefas, &Tarefa.completada?(&1) == false)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Retorna a lista ordenada, com as tarefas completadas no final da lista
  """
  def ordenar(tarefas) do
    completadas = Enum.filter(tarefas, &Tarefa.completada?/1)
    sem_completar = Enum.reject(tarefas, &Tarefa.completada?/1)
    sem_completar ++ completadas
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Imprime os elementos da lista no console
  """
  def imprimir(tarefas) do
    Enum.each(tarefas, &Tarefa.imprimir/1)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e outra struct do tipo Tarefa

  Insere a struct no final da lista
  """
  def inserir(tarefas, tarefa) do
    [tarefas, tarefa] |> List.flatten()
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, outra struct do tipo Tarefa e uma posição

  Insere a struct na posição indicada da lista
  """
  def inserir(tarefas, tarefa, posicao) do
    posicao = max(posicao, 0) # se posicao < 0, posicao = 0
    List.insert_at(tarefas, posicao, tarefa)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, um inteiro origem e um inteiro destino

  Insere a tarefa da posição origem na posição destino

  Retorna a lista de tarefas com a nova ordem
  """
  def mover(tarefas, origem, destino) when origem > destino and origem > length(tarefas) do
    mover(tarefas, length(tarefas) - 1, destino)
  end

  def mover(tarefas, origem, destino) when origem == destino and
    (length(tarefas) < destino or length(tarefas) < origem) do tarefas end

  def mover(tarefas, origem, destino) when origem == destino and
    (destino < 0 or origem < 0) do tarefas end

  def mover(tarefas, origem, destino) do
    origem = max(origem, 0)
    tarefa = Enum.at(tarefas, origem)
    temp_tarefas = List.delete_at(tarefas, origem)
    inserir(temp_tarefas, tarefa, destino)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Remove a tarefa na posição indicada da lista de tarefas

  Retorna a lista de tarefas sem a tarefa removida
  """
  def remover(tarefas, posicao) do
    posicao = max(posicao, 0)
    posicao = min(posicao, length(tarefas) -1)
    List.delete_at(tarefas, posicao)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como completada

  Retorna a lista de tarefas com a tarefa completada
  """
  def completar(tarefas, posicao) do
    posicao = posicao
      |> max(0)
      |> min(length(tarefas) -1)

    completar = Enum.at(tarefas, posicao)
    completada = Tarefa.completar(completar)

    tarefas
      |> remover(posicao)
      |> inserir(completada, posicao)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como sem completar

  Retorna a lista de tarefas com a tarefa sem completar
  """
  def reiniciar(tarefas, posicao) do
    posicao = max(posicao, 0)
    posicao = min(posicao, length(tarefas) -1)

    reiniciar = Enum.at(tarefas, posicao)
    reiniciar = Tarefa.reiniciar(reiniciar)

    tarefas = remover(tarefas, posicao)
    inserir(tarefas, reiniciar, posicao)
  end
end
