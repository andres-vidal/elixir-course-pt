defmodule HtmlTreeTest do
  @moduledoc false
  use ExUnit.Case

  describe "merge_nested_anchors" do
    test "merges directly nested anchors" do
      input =
        {[
           {:div,
            [
              {:a,
               [
                 {:a, [{:text, "Hello"}, {:a, {:text, "World"}}]}
               ]}
            ]}
         ]}

      expected_output =
        {[
           {:div,
            [
              {:a, [{:text, "Hello"}, {:text, "World"}]}
            ]}
         ]}

      assert expected_output == HtmlTree.merge_nested_anchors(input)
    end
  end
end
