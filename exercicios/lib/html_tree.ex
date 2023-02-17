defmodule HtmlTree do
  def merge_nested_anchors({children} = _root_node)
      when is_list(children) do
    {Enum.concat(merge_nested_anchors(children, false))}
  end

  def merge_nested_anchors({:a, children}, _bypass_anchors = true)
      when is_list(children) do
    Enum.concat(merge_nested_anchors(children, true))
  end

  def merge_nested_anchors({tag, children}, bypass_anchors)
      when is_list(children) do
    [{tag, Enum.concat(merge_nested_anchors(children, bypass_anchors or tag == :a))}]
  end

  def merge_nested_anchors({:text, _text} = text_node, _bypass_anchors) do
    [text_node]
  end

  def merge_nested_anchors(nodes, bypass_anchors)
      when is_list(nodes) and is_boolean(bypass_anchors) do
    Enum.map(nodes, fn node -> merge_nested_anchors(node, bypass_anchors) end)
  end
end
