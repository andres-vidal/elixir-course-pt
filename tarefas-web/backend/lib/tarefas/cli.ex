defmodule Tarefas.CLI do
  @moduledoc """
  Módulo para a interface de linha de comandos do aplicativo
  """

  @uuid Application.compile_env(:tarefas, :uuid)

  alias ElixirSense.Core.Introspection
  alias Tarefas.Tarefa

  @doc """
  Ponto de entrada do aplicativo por linha de comandos.

  Recebe os comandos passados na linha de comandos como uma lista de strings.

  Lê o arquivo de tarefas, processa as tarefas segundo os comandos recebidos e salva o resultado.
  """
  def main(comandos) do
    Tarefas.ler()
    |> Tarefas.CLI.processar(comandos)
    |> Tarefas.salvar()
  end

  @doc """
  Recebe uma lista de structs do tipo Tarefa e uma lista de comandos

  Processa a lista segundo os comandos recebidos

  Retorna o resultado do processamento
  """


 def processar(tarefas,[]) when is_list(tarefas) do
    tarefas=Enum.filter(tarefas,fn tarefa -> Tarefas.Tarefa.completada?(tarefa) end)
    tarefas=Enum.each(tarefas, fn tarefa -> Tarefas.Tarefa.imprimir(tarefa) end)
 end
  #nova tarefa
 def processar(tarefas,[nova]) when is_list(tarefas) do
    tarefas=List.insert_at(tarefas,-1,Tarefas.Tarefa.decodificar( ",#{nova},sem_completar"))
 end
  #Completar
  def processar(tarefas,["completar",x])do
    x=String.to_integer(x)
    tarefa=Tarefas.Tarefa.completar(Enum.at(tarefas,x))
    tarefas=List.replace_at(tarefas,x,tarefa)
    IO.inspect(tarefas)
  end

#Reiniciar
def processar(tarefas,["reiniciar",x])do
  x=String.to_integer(x)
  tarefa=Tarefas.Tarefa.reiniciar(Enum.at(tarefas,x))
  tarefas=List.replace_at(tarefas,x,tarefa)
  IO.inspect(tarefas)
end

#Remover
def processar(tarefas,["remover",x])do
  x=String.to_integer(x)
  List.delete_at(tarefas,x)
end

 #Mover a tarefa
 def processar(tarefas,["mover", origem, destino])do
    origem=String.to_integer(origem)
    destino=String.to_integer(destino)

    tarefa=Enum.at(tarefas,origem)
    tarefa1=Tarefas.Tarefa.strToList(tarefa)
    tarefa_nome=Enum.at(tarefa1,1)

    tarefas=Enum.reject(tarefas, fn tarefa -> Tarefas.Tarefa.getDescricao(tarefa)==tarefa_nome  end)
    # tarefas=Enum.reject(tarefas,fn {descri,_estado} -> descri==tarefa end)
    # tarefaE=Enum.at(tarefaE,0)
    tarefas=List.insert_at(tarefas,destino,tarefa)
    tarefas
 end

  # Adicionar no começo da lista
  def processar(tarefas,[nova,x="0"]) when nova != "remover" do
    x=String.to_integer(x)
    tarefas=List.insert_at(tarefas,0,Tarefas.Tarefa.decodificar( ",#{nova},sem_completar"))
  end

  #Todas
  def processar(tarefas,"todas")do
      completas=Enum.filter(tarefas,fn tarefa -> Tarefas.Tarefa.completada?(tarefa) end)
      incompletas=Enum.reject(tarefas,fn tarefa -> Tarefas.Tarefa.completada?(tarefa) end)
      Enum.map(incompletas, fn tarefa -> Tarefas.Tarefa.imprimir(tarefa) end)
      IO.puts("\n-- Tarefas Completadas --")
      Enum.map(completas, fn tarefa -> Tarefas.Tarefa.imprimir(tarefa) end)
      tarefas
  end
  #Adicionar em uma posição
  def processar(tarefas,[nova,x]) when nova !="remover" do
    x=String.to_integer(x)
    tarefas=List.insert_at(tarefas,x,Tarefas.Tarefa.decodificar( ",#{nova},sem_completar"))
  end

end
