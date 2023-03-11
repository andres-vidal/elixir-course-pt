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
  def completar(%Tarefa{id: id, descricao: descricao}) do
    %Tarefa{id: id, descricao: descricao, estado: "completada"}
  end

  @doc """
  Recebe uma struct do tipo Tarefa

  Retorna uma struct do tipo Tarefa com os mesmo dados e estado "sem_completar"
  """
  def reiniciar(%Tarefa{id: id, descricao: descricao}) do
    %Tarefa{descricao: descricao, estado: "sem_completar", id: id}
  end

  @doc """
  Recebe uma struct do tipo Tarefa

  Retorna verdadeiro se seu estado for "completada" ou falso se não
  """
  def completada?(%Tarefa{estado: estado}) do
    estado === "completada"
  end

  @doc """
  Recebe uma struct do tipo Tarefa

  Codifica a struct numa string com o formato "id,descricao,estado"
  """
  def codificar(%Tarefa{id: id, descricao: descricao, estado: estado}) do
    "#{id},#{descricao},#{estado}"
  end

  @doc """
  Recebe uma string com o formato "id,descricao,estado"

  Retorna uma struct do tipo Tarefa com os conteúdos da string
  """
  def decodificar(string) do
    [id, descricao,  estado] = string |> String.split(",")
    %Tarefa{id: id, descricao: descricao, estado: estado}
  end

  @doc """
  Recebe uma struct do tipo tarefa

  Imprime a struct no console
  """
  def imprimir(%Tarefa{descricao: descricao}) do
    IO.puts(descricao)
  end
end
