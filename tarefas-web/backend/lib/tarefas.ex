defmodule Tarefas do
  @moduledoc """
  Módulo com utilidades gerais para a manipulação de listas de tarefas e do arquivo de tarefas
  """

  alias ElixirSense.Providers.Suggestion.Reducers.Struct
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

  def tarefas do ler() end

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
    string=String.split(string,"\n")
    string=if Enum.at(string,-1) == "" do string=List.delete_at(string,-1) else string end

    #string=List.delete_at(string,-1)
    string=Enum.map(string,fn tarefa -> Tarefas.Tarefa.decodificar(tarefa)  end)
    string
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Codifica a lista em uma string unindo as structs codificadas com quebras de linha. Adiciona uma linha vazia no final.

  Retorna a string codificada
  """

  def codificar(tarefas) do
    tarefas=Enum.map(tarefas,fn tarefa -> "#{Tarefas.Tarefa.codificar(tarefa)}\n" end)
    List.to_string(tarefas)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e um booleano completadas?

  Se completadas? for verdadeiro, retorna os elementos com o estado "completada"
  Se completadas? for falso, retorna os elementos com o estado "sem_completar"
  """
  def filtrar(tarefas,completadas?: completa?) do
    #Tarefas.Tarefa.getEstado(tarefa)
    tarefas=Enum.filter(tarefas,fn tarefa -> Tarefas.Tarefa.completada?(tarefa) == completa? end)
    # tarefas
    #Tarefas.Tarefa.completada?( Enum.at(tarefas,1))
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Retorna a lista ordenada, com as tarefas completadas no final da lista
  """
  def ordenar(tarefas) do
    semcompletar=filtrar(tarefas,completadas?: false)
    completadas=filtrar(tarefas,completadas?: true)
    resultado= semcompletar++completadas
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa

  Imprime os elementos da lista no console
  """
  def imprimir(tarefas) do
    Enum.map(tarefas,fn tarefa -> IO.puts(Tarefas.Tarefa.getDescricao(tarefa)) end)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e outra struct do tipo Tarefa

  Insere a struct no final da lista
  """
  def inserir(tarefas,nova) do
    List.insert_at(tarefas,-1,nova)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, outra struct do tipo Tarefa e uma posição

  Insere a struct na posição indicada da lista
  """
  def inserir(tarefas,nova,onde)when onde<0 do
    #onde=String.to_integer(onde)
    List.insert_at(tarefas,0,nova)
  end

  def inserir(tarefas,nova,onde) do
    #onde=String.to_integer(onde)
    List.insert_at(tarefas,onde,nova)
  end

  def inserir([],nova) do
    #onde=String.to_integer(onde)
      [nova]
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa, um inteiro origem e um inteiro destino

  Insere a tarefa da posição origem na posição destino

  Retorna a lista de tarefas com a nova ordem
  """
  def mover(tarefas,origem,destino)when origem<0 and destino<0 or destino>length(tarefas) and origem==destino do
    tarefas
  end

  def mover(tarefas,origem,destino)when origem>length(tarefas) do
    # origem=String.to_integer(origem)
    # destino=String.to_integer(destino)
    origem=-1
    tarefa=Enum.at(tarefas,origem)
    tarefa1=Tarefas.Tarefa.strToList(tarefa)
    tarefa_nome=Enum.at(tarefa1,1)

    tarefas=Enum.reject(tarefas, fn tarefa -> Tarefas.Tarefa.getDescricao(tarefa)==tarefa_nome  end)
    # tarefas=Enum.reject(tarefas,fn {descri,_estado} -> descri==tarefa end)
    # tarefaE=Enum.at(tarefaE,0)
    tarefas=List.insert_at(tarefas,destino,tarefa)
    # tarefas
  end

  def mover(tarefas,origem,destino)when origem<0 do
    # origem=String.to_integer(origem)
    # destino=String.to_integer(destino)
    origem=0
    tarefa=Enum.at(tarefas,origem)
    tarefa1=Tarefas.Tarefa.strToList(tarefa)
    tarefa_nome=Enum.at(tarefa1,1)

    tarefas=Enum.reject(tarefas, fn tarefa -> Tarefas.Tarefa.getDescricao(tarefa)==tarefa_nome  end)
    # tarefas=Enum.reject(tarefas,fn {descri,_estado} -> descri==tarefa end)
    # tarefaE=Enum.at(tarefaE,0)
    tarefas=List.insert_at(tarefas,destino,tarefa)
    # tarefas
  end

  def mover(tarefas,origem,destino)when origem>destino and destino<0 do
    # origem=String.to_integer(origem)
    # destino=String.to_integer(destino)
    destino=0
    tarefa=Enum.at(tarefas,origem)
    tarefa1=Tarefas.Tarefa.strToList(tarefa)
    tarefa_nome=Enum.at(tarefa1,1)

    tarefas=Enum.reject(tarefas, fn tarefa -> Tarefas.Tarefa.getDescricao(tarefa)==tarefa_nome  end)
    # tarefas=Enum.reject(tarefas,fn {descri,_estado} -> descri==tarefa end)
    # tarefaE=Enum.at(tarefaE,0)
    tarefas=List.insert_at(tarefas,destino,tarefa)
    # tarefas
  end

  def mover(tarefas,origem,destino) do
    # origem=String.to_integer(origem)
    # destino=String.to_integer(destino)

    tarefa=Enum.at(tarefas,origem)
    tarefa1=Tarefas.Tarefa.strToList(tarefa)
    tarefa_nome=Enum.at(tarefa1,1)

    tarefas=Enum.reject(tarefas, fn tarefa -> Tarefas.Tarefa.getDescricao(tarefa)==tarefa_nome  end)
    # tarefas=Enum.reject(tarefas,fn {descri,_estado} -> descri==tarefa end)
    # tarefaE=Enum.at(tarefaE,0)
    tarefas=List.insert_at(tarefas,destino,tarefa)
    # tarefas
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Remove a tarefa na posição indicada da lista de tarefas

  Retorna a lista de tarefas sem a tarefa removida
  """

  def remover(tarefas,x)when x<0 do
    List.delete_at(tarefas,0)
  end

  def remover(tarefas,x)when x>length(tarefas) do
    List.delete_at(tarefas,-1)
  end

  def remover(tarefas,x) do
    List.delete_at(tarefas,x)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como completada

  Retorna a lista de tarefas com a tarefa completada
  """
  def completar(tarefas,x)when x<0 do
    tarefa=Tarefas.Tarefa.completar(Enum.at(tarefas,0))
    tarefas=List.replace_at(tarefas,0,tarefa)
  end

  def completar(tarefas,x)when x>length(tarefas) do
    tarefa=Tarefas.Tarefa.completar(Enum.at(tarefas,-1))
    tarefas=List.replace_at(tarefas,-1,tarefa)
  end

  def completar(tarefas,x) do
    tarefa=Tarefas.Tarefa.completar(Enum.at(tarefas,x))
    tarefas=List.replace_at(tarefas,x,tarefa)
    IO.inspect(tarefas)
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma posição

  Marca a tarefa da posição fornecida na lista de tarefas como sem completar

  Retorna a lista de tarefas com a tarefa sem completar
  """

  def reiniciar(tarefas,x)when x<0 do
    tarefa=Tarefas.Tarefa.reiniciar(Enum.at(tarefas,0))
    tarefas=List.replace_at(tarefas,0,tarefa)
  end

  def reiniciar(tarefas,x)when x>length(tarefas) do
    tarefa=Tarefas.Tarefa.reiniciar(Enum.at(tarefas,-1))
    tarefas=List.replace_at(tarefas,-1,tarefa)
  end

  def reiniciar(tarefas,x) do
    tarefa=Tarefas.Tarefa.reiniciar(Enum.at(tarefas,x))
    tarefas=List.replace_at(tarefas,x,tarefa)
  end
end
