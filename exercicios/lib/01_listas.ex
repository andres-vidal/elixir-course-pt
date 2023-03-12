defmodule Listas do
  @moduledoc """
  Exercicios sobre listas
  """

  @doc """
  Recebe duas listas
  Retorna uma única lista com os elementos da segunda após os da primeira

  Exemplos

    iex> Listas.concat([1, 2, 3], [4, 5, 6])
    [1, 2, 3, 4, 5, 6]

    iex> Listas.concat(["a", "b", "c"], ["d", "e"])
    ["a", "b", "c", "d", "e"]

    iex> Listas.concat([1, "a", 3], [nil])
    [1, "a", 3, nil]
  """
  def concat(a, b) do
    a ++ b
  end

  @doc """
  Recebe uma lista e um elemento
  Retorna uma única lista com o elemento recebido após os elementos da lista

  Exemplos

    iex> Listas.append([1, 2, 3], 4)
    [1, 2, 3, 4]

    iex> Listas.append([1, "b", 3], "d")
    [1, "b", 3, "d"]

    iex> Listas.append([1, "a", 3], nil)
    [1, "a", 3, nil]
  """
  def append(list, el) when is_list(list) do
    list ++ [el] 
  end

  @doc """
  Recebe uma lista e um elemento
  Retorna uma única lista com o elemento recebido antes dos elementos da lista

  Exemplos

    iex> Listas.prepend([1, 2, 3], 4)
    [4, 1, 2, 3]

    iex> Listas.prepend([1, "b", 3], "d")
    ["d", 1, "b", 3]

    iex> Listas.prepend([1, "a", 3], nil)
    [nil, 1, "a", 3]
  """
  def prepend(list, el) when is_list(list) do 
    [el | list]
  end

  @doc """
  Recebe uma lista
  Retorna o primeiro elemento da lista

  Exemplos

    iex> Listas.head([1, 2, 3, 4])
    1

    iex> Listas.head(["a", "b", 3, "d"])
    "a"

    iex> Listas.head([nil, 1, "a", 3])
    nil

  """
  def head([head | t]) do
    head
  end

  @doc """
  Recebe uma lista
  Retorna o primeiro elemento da lista

  Exemplos

    iex> Listas.tail([1, 2, 3, 4])
    [2, 3, 4]

    iex> Listas.tail(["a", "b", 3, "d"])
    ["b", 3, "d"]

    iex> Listas.tail([nil, 1, "a", 3])
    [1, "a", 3]
  """
  def tail([h | tail]) do
    tail
  end

  @doc """
  Recebe uma lista de inteiros e um valor x
  Retorna uma lista com todos os elementos da lista recebida com o valor x somado

  Exemplos
    iex> Listas.sum([1, 2, 3, 4], 1)
    [2, 3, 4, 5]

    iex> Listas.sum([1, 2, 3, 4], 5)
    [6, 7, 8, 9]
  """

  def sum([], add) do [] end
  def sum([head | tail], add) do
    [head + add] ++ sum(tail, add)
  end

  @doc """
  Recebe uma lista de inteiros e um valor x
  Retorna a lista sem o elemento x

  Exemplos
    iex> Listas.remove([1, 2, 3, 4], 1)
    [2, 3, 4]

    iex> Listas.remove([1, 2, 3, 4, 2, 3], 2)
    [1, 3, 4, 3]

    iex> Listas.remove([nil, nil, nil, 4, 2, 3], nil)
    [4, 2, 3]
  """

  def remove([], n) do [] end
  def remove([a | b], n) when a === n do
    remove(b, n)
  end
  def remove([a | b], n) do
    [a] ++ remove(b, n)
  end

  @doc """
  Recebe uma lista de inteiros
  Retorna a quantidade de elementos na lista

  Exemplos
    iex> Listas.count([])
    0

    iex> Listas.count([1, 2, 3, 4])
    4

    iex> Listas.count([1, 2, 3, 4, 2, 3])
    6

    iex> Listas.count([nil, nil, nil, 4, 2, 3])
    6
  """
  def count([]) do 0 end
  def count([head | tail]) do
    1 + count(tail)
  end

  @doc """
  Recebe uma lista de inteiros
  Retorna a quantidade de elementos não nulos da lista

  Exemplos
    iex> Listas.count_not_null([])
    0

    iex> Listas.count_not_null([1, 2, 3, 4])
    4

    iex> Listas.count_not_null([1, 2, 3, 4, 2, 3])
    6

    iex> Listas.count_not_null([nil, nil, nil, 4, 2, 3])
    3
  """
  def count_not_null([]) do 0 end
  def count_not_null([head | tail]) when head===nil do 
    count_not_null(tail)
  end
  def count_not_null([head | tail]) do 
    1 + count_not_null(tail) 
  end

  @doc """
  Recebe uma lista de inteiros e um inteiro
  Retorna `true` se o inteiro estiver na lista e `false` se no caso contrário

  Exemplos
    iex> Listas.includes?([], 0)
    false

    iex> Listas.includes?([0, 1, 2, 3], 0)
    true

    iex> Listas.includes?([nil, nil, nil, 4, 2, 3], 3)
    true

    iex> Listas.includes?([4, 2, nil, 3], nil)
    true

    iex> Listas.includes?([1, 2, 3, 4, 2, 3], nil)
    false

    iex> Listas.includes?([1, 2, 3, 4, 2, 3], 0)
    false
  """
  def includes?([], n) do false end
  def includes?([head | tail], n) when head === n do 
    true
  end
  def includes?([head | tail], n) do 
    includes?(tail, n)
  end

  @doc """
  Recebe uma lista de inteiros e uma função
  Retorna uma lista com a função aplicada em cada um dos elementos da lista recebida

  Exemplos
    iex> Listas.map([], fn n -> n + 1 end)
    []

    iex> Listas.map([1, 1, 1, 1, 1, 1], fn n -> n + 1 end)
    [2, 2, 2, 2, 2, 2]

    iex> Listas.map([1, 2, 3, 4, 2, 3], fn n -> n * n end)
    [1, 4, 9, 16, 4, 9]

    iex> Listas.map([nil, nil, nil, 4, 2, 3], fn n -> case n do nil -> 0; _ -> n end end)
    [0, 0, 0, 4, 2, 3]
  """
  def map([], f) do [] end
  def map([head | tail], f) do
    [f.(head)] ++ map(tail, f)  
  end

  @doc """
  Recebe uma lista de inteiros e uma função que retorna `true` ou `false`
  Retorna uma lista com os elementos para os quais a função recebida retorna `true`

  Exemplos
    iex> Listas.filter([], fn _n -> true end)
    []

    iex> Listas.filter([1, 1, 1, 1, 1, 1], fn n -> n != 1 end)
    []

    iex> Listas.filter([1, 2, 3, 4, 2, 3], fn n -> n != 4 end)
    [1, 2, 3, 2, 3]

    iex> Listas.filter([nil, nil, nil, 4, 2, 3], fn n -> not is_nil(n) end)
    [4, 2, 3]
  """
  def filter([], f) do [] end
  def filter([head | tail], f) do
    if f.(head) do 
      [head] ++ filter(tail, f)
    else 
      filter(tail, f)
    end
  end

  @doc """
  Recebe uma lista de listas
  Retorna uma lista com os elementos de todas as sublistas

  Exemplos
  iex> Listas.flatten([])
  []

  Exemplos
  iex> Listas.flatten([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
  [1, 2, 3, 4, 5, 6, 7, 8, 9]

  Exemplos
  iex> Listas.flatten([["a", "b", "d"], ["c", "f", "g"], ["j", "l", "z"]])
  ["a", "b", "d", "c", "f", "g", "j", "l", "z"]

  """
  def flatten([]) do [] end
  def flatten([head | tail]) when is_list(head) do
    head ++ flatten(tail)
  end

  @doc """
  Recebe uma lista de inteiros e remove os elementos duplicados
  Retorna `true` se o inteiro estiver na lista e `false` se no caso contrário

  Exemplos
    iex> Listas.unique([])
    []

    iex> Listas.unique([1, 1, 1, 1, 1, 1])
    [1]

    iex> Listas.unique([1, 2, 3, 4, 2, 3])
    [1, 2, 3, 4]

    iex> Listas.unique([nil, nil, nil, 4, 2, 3])
    [nil, 4, 2, 3]
  """

  # def unique([]) do [] end
  def unique(list) do
    unique_helper(list, [])
  end

  def unique_helper([], acc) do acc end
  def unique_helper([head | tail], acc) do
    unique_helper(tail, adicionar_se_nao_existe(head, acc))
  end

  def adicionar_se_nao_existe(elemento, lista) do 
    if includes?(lista, elemento) do 
      lista
    else
      lista ++ [elemento]
    end
  end

  @doc """
  Recebe uma lista, um valor inicial e uma função que recebe um acumulador e um elemento e retorna um acumulador
  Aplica a função sobre a lista e o valor acumulado pelos elementos ja recorridos na lista
  Retorna uma lista com os elementos para os quais a função recebida retorna `true`

  Exemplos
    iex> Listas.reduce([], [], fn acc, _n -> acc end)
    []

    # Conta a quantidade de elementos na lista
    iex> Listas.reduce([1, 1, 1, 1, 1, 1], 0, fn acc, _n -> acc + 1 end)
    6

    # Soma os elementos da lista
    iex> Listas.reduce([2, 2, 1, 1, 1, 1], 0, fn acc, n -> acc + n end)
    8

    iex> Listas.reduce([2, 2, 1, 1, 1, 1], [], fn acc, n -> acc ++ [[n]] end)
    [[2], [2], [1], [1], [1], [1]]

    iex> Listas.reduce([2, 3, 5, 7, 11], 1, fn acc, n -> acc * n end)
    2310

    iex> Listas.reduce([[1, 2, 3], [4, 5, 6], [7, 8, 9]], [], fn acc, l -> acc ++ l end)
    [1, 2, 3, 4, 5, 6, 7, 8, 9]
  """
  def reduce([], ini, _f) do ini end
  def reduce([head | tail], ini, f) do
    reduce(tail, f.(ini, head), f)
  end
end
