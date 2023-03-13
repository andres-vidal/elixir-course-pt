defmodule Tarefas.Tarefa do
  @moduledoc """
  Módulo com a definição da struct Tarefa e com utilizades para a sua manipulação individual
  """

  alias Tarefas.Tarefa

  @derive {Jason.Encoder, [:descricao, :estado]}
  @enforce_keys [:descricao]
  defstruct id: "", descricao: nil, estado: "sem_completar"

  @doc """
  Recebe uma struct do tipo Tarefa

  Retorna uma struct do tipo Tarefa com os mesmo dados e estado "completada"
  """
  def completar(%Tarefa{id: id,descricao: descricao, estado: estado}) do
    %Tarefa{id: id,descricao: descricao,estado: "completada"}
  end

  @doc """
  Recebe uma struct do tipo Tarefa

  Retorna uma struct do tipo Tarefa com os mesmo dados e estado "sem_completar"
  """
  def reiniciar(%Tarefa{id: id,descricao: descricao, estado: estado}) do
    %Tarefa{id: id,descricao: descricao,estado: "sem_completar"}
  end

  @doc """
  Recebe uma struct do tipo Tarefa

  Retorna verdadeiro se seu estado for "completada" ou falso se não
  """
  def completada?(%Tarefa{id: id,descricao: descricao, estado: estado}) do
    estado==="completada"
  end

  @doc """
  Recebe uma struct do tipo Tarefa

  Codifica a struct numa string com o formato "id,descricao,estado"
  """
  def codificar(%Tarefa{id: id,descricao: descricao, estado: estado}) do
    "#{id},#{descricao},#{estado}"
  end

  @doc """
  Recebe uma string com o formato "id,descricao,estado"

  Retorna uma struct do tipo Tarefa com os conteúdos da string
  """
  def decodificar(string) do
    string=String.split(string,",")
    %Tarefa{id: Enum.at(string,0),descricao: Enum.at(string,1), estado: Enum.at(string,2)}
  end


  @doc """
  Recebe uma struct do tipo tarefa

  Imprime a struct no console
  """
  def imprimir( %Tarefa{id: id,descricao: tarefa,estado: estado}) do
      IO.puts(tarefa)
  end

  def strToList(%Tarefa{id: id,descricao: descricao, estado: estado})do
    [id,descricao,estado]
  end

  def getDescricao(%Tarefa{id: id,descricao: descricao, estado: estado})do
      descricao
  end

  def getEstado(%Tarefa{id: id,descricao: descricao, estado: estado})do
    estado
  end

  def getId(%Tarefa{id: id,descricao: descricao, estado: estado})do
    id
  end

end
