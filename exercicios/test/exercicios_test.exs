defmodule ExerciciosTest do
  use ExUnit.Case
  doctest Exercicios

  test "greets the world" do
    assert Exercicios.hello() == :world
  end
end
