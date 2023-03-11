import { FC, KeyboardEventHandler, useState } from "react";
import { useQuery } from "react-query";
import { Backend } from "./backend";
import IconoCirculoMais from "./IconoCirculoMais";
import c from "classnames";

type Props = { onFocus: () => void; onBlur: () => void };

const TarefaNova: FC<Props> = ({ onFocus, onBlur }) => {
  const [descricao, setDescricao] = useState("");
  const [isFocused, setIsFocused] = useState(false);

  const { refetch } = useQuery({ queryKey: ["tarefas"], enabled: false });

  const submit = async () => {
    if (descricao) {
      await Backend.criar(descricao);
      setDescricao("");
      refetch();
    }
  };

  const handleKeyDown: KeyboardEventHandler = async (e) => {
    if (e.key === "Enter") {
      submit();
    }
  };

  return (
    <div
      className={c("flex items-center w-full p-2 space-x-4 bg-white", {
        "bg-slate-200": isFocused,
      })}
    >
      <button
        className={c("flex hover:text-indigo-700", {
          "text-indigo-700": isFocused,
        })}
        onClick={submit}
        disabled={!descricao}
      >
        <IconoCirculoMais className="inline h-5" />
      </button>

      <input
        className="bg-transparent outline-none"
        placeholder="Adicionar nova tarefa"
        value={descricao}
        onChange={(e) => setDescricao(e.target.value)}
        onKeyDown={handleKeyDown}
        onFocus={() => {
          onFocus();
          setIsFocused(true);
        }}
        onBlur={() => {
          onBlur();
          setIsFocused(false);
        }}
      />
    </div>
  );
};

export default TarefaNova;
