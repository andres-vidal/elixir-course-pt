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
		|> Enum.map(fn linha ->
			[id, descricao, estado] = String.split(linha, ",", parts: 2)
			%{id: id, descricao: descricao, estado: estado}
		end)
	end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Codifica a lista em uma string unindo as structs codificadas com quebras de linha. Adiciona uma linha vazia no final.

  Retorna a string codificada
  """

  def codificar(_) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e um booleano completadas?

  Se completadas? for verdadeiro, retorna os elementos com o estado "completada"
  Se completadas? for falso, retorna os elementos com o estado "sem_completar"
  """
  def filtrar(_, _) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Retorna a lista ordenada, com as tarefas completadas no final da lista
  """
  def ordenar(_) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Imprime os elementos da lista no console
  """
  def imprimir(_) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e outra struct do tipo Tarefa

  Insere a struct no final da lista
  """
  def inserir(_, _) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, outra struct do tipo Tarefa e uma posição

  Insere a struct na posição indicada da lista
  """
  def inserir(_, _, _) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, um inteiro origem e um inteiro destino

  Insere a tarefa da posição origem na posição destino

  Retorna a lista de tarefas com a nova ordem
  """
  def mover(_, _, _) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Remove a tarefa na posição indicada da lista de tarefas

  Retorna a lista de tarefas sem a tarefa removida
  """
  def remover(_, _) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como completada

  Retorna a lista de tarefas com a tarefa completada
  """
  def completar(_, _) do
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como sem completar

  Retorna a lista de tarefas com a tarefa sem completar
  """
  def reiniciar(_, _) do
  end
end
