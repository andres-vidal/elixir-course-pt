defmodule Tarefas do
  @moduledoc """
  Módulo com utilidades gerais para a manipulação de listas de tarefas e do arquivo de tarefas
  """

  alias Tarefas.Tarefa, as: Tarefa

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
  def decodificar(string) do
    string
    |> String.split("\n")
    |> Enum.filter(fn string -> "" != String.trim(string) end)
    |> Enum.map(&Tarefa.decodificar/1)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Codifica a lista em uma string unindo as structs codificadas com quebras de linha. Adiciona uma linha vazia no final.

  Retorna a string codificada
  """

  def codificar(tarefas) do
    tarefas
    |> Enum.map(fn %Tarefa{id: id, descricao: descricao, estado: estado} -> [id, descricao, estado] end)
    |> Enum.map(fn lista -> Enum.join(lista, ",") end)
    |> Kernel.++([""])
    |> Enum.join("\n")
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e um booleano completadas?

  Se completadas? for verdadeiro, retorna os elementos com o estado "completada"
  Se completadas? for falso, retorna os elementos com o estado "sem_completar"
  """
  def filtrar(tarefas, [completadas?: true]) when is_list(tarefas) do
    tarefas
    |> Enum.filter(&Tarefa.completada?/1)
  end
  def filtrar(tarefas, [completadas?: false]) when is_list(tarefas) do
    tarefas
    |> Enum.reject(&Tarefa.completada?/1)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Retorna a lista ordenada, com as tarefas completadas no final da lista
  """
  def ordenar(tarefas) when is_list(tarefas) do
    filtrar(tarefas, [completadas?: false]) ++ filtrar(tarefas, [completadas?: true])
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Imprime os elementos da lista no console
  """

  def imprimir(tarefas) do
    tarefas
    |> Enum.map(&Tarefa.imprimir/1)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e outra struct do tipo Tarefa

  Insere a struct no final da lista
  """
  def inserir(tarefas, tarefa) when is_list(tarefas) do
    tarefas ++ [tarefa]
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, outra struct do tipo Tarefa e uma posição

  Insere a struct na posição indicada da lista
  """
  def inserir(tarefas, tarefa, posicao) when is_list(tarefas) and posicao < 0 do
    [tarefa] ++ tarefas
  end
  def inserir(tarefas, tarefa, posicao) when is_list(tarefas) do
    tarefas |> List.insert_at(posicao, tarefa)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, um inteiro origem e um inteiro destino

  Insere a tarefa da posição origem na posição destino

  Retorna a lista de tarefas com a nova ordem
  """

  def mover(tarefas, origem, destino) when destino === origem do
    tarefas
  end

  def mover(tarefas, origem, destino) when origem < 0 and origem < destino do
    tarefa = Enum.at(tarefas, 0)
    tarefas
    |> List.delete_at(0)
    |> List.insert_at(destino, tarefa)
  end

  def mover(tarefas, origem, destino) when destino < 0 and origem > destino do
    tarefa = Enum.at(tarefas, origem)
    tarefas
    |> List.delete_at(origem)
    |> List.insert_at(0, tarefa)
  end

  def mover(tarefas, origem, destino) when destino > Kernel.length(tarefas)-1 and origem > destino do
    ultima_pos = Kernel.length(tarefas)-1
    [Enum.at(ultima_pos, tarefas)] ++ tarefas |> remover(ultima_pos)
  end

  def mover(tarefas, origem, destino) when origem > Kernel.length(tarefas)-1 and origem > destino do
    ultima_pos = Kernel.length(tarefas)-1
    tarefa = Enum.at(tarefas, ultima_pos)
    tarefas
    |> List.delete_at(ultima_pos)
    |> List.insert_at(destino, tarefa)
  end

  def mover(tarefas, origem, destino) when is_list(tarefas) do
    tarefa = Enum.at(tarefas, origem)
    tarefas
    |> List.delete_at(origem)
    |> List.insert_at(destino, tarefa)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Remove a tarefa na posição indicada da lista de tarefas

  Retorna a lista de tarefas sem a tarefa removida
  """
  def remover(tarefas, posicao) when posicao > Kernel.length(tarefas)-1 do
    tarefas |> List.delete_at(Kernel.length(tarefas)-1)
  end
  def remover([_head | tarefas], posicao) when posicao < 0 do
    tarefas
  end
  def remover(tarefas, posicao) when is_list(tarefas) do
    tarefas |> List.delete_at(posicao)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como completada

  Retorna a lista de tarefas com a tarefa completada
  """

  def completar([primeira_tarefa | tarefas], posicao) when posicao < 0 do
    [Tarefa.completar(primeira_tarefa)] ++ tarefas
  end
  def completar(tarefas, posicao) when is_list(tarefas) and posicao > Kernel.length(tarefas)-1 do
    ultima_pos = Kernel.length(tarefas)-1
    ultima_tarefa = tarefas |> Enum.at(ultima_pos)
    tarefas
    |> List.replace_at(ultima_pos, Tarefa.completar(ultima_tarefa))
  end
  def completar(tarefas, posicao) when is_list(tarefas) do
    tarefa = Enum.at(tarefas, posicao)
    tarefas
    |> List.replace_at(posicao, Tarefa.completar(tarefa))
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como sem completar

  Retorna a lista de tarefas com a tarefa sem completar
  """
  def reiniciar([primeira_tarefa | tarefas], posicao) when posicao < 0 do
    [Tarefa.reiniciar(primeira_tarefa)] ++ tarefas
  end
  def reiniciar(tarefas, posicao) when posicao > Kernel.length(tarefas) - 1 do
    ultima_pos = Kernel.length(tarefas)-1
    ultima_tarefa = tarefas |> Enum.at(ultima_pos)
    tarefas
    |> List.replace_at(ultima_pos, Tarefa.reiniciar(ultima_tarefa))
  end
  def reiniciar(tarefas, posicao) do
    tarefa = Enum.at(tarefas, posicao)
    tarefas
    |> List.replace_at(posicao, Tarefa.reiniciar(tarefa))
  end
end
