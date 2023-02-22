import { FC } from "react";
import IconoLixo from "./IconoLixo";
import c from "classnames";
import IconoCirculoTick from "./IconoCirculoTick";
import IconoCirculo from "./IconoCirculo";

type Tarefa = {
  id: string;
  descricao: string;
  estado: "completada" | "sem_completar";
};

type Props = Tarefa & {
  draggedId?: string;
  onRemover: () => void;
  onStatusClick: () => void;
};

const Tarefa: FC<Props> = ({
  id,
  descricao,
  estado,
  draggedId,
  onRemover,
  onStatusClick,
}) => {
  const isAnyDragging = !!draggedId;
  const isDragging = id === draggedId;

  return (
    <div
      className={c("flex justify-between p-2 bg-white group cursor-grab", {
        "hover:bg-indigo-100": !isAnyDragging,
        "bg-indigo-100": isDragging,
      })}
    >
      <span className="flex items-center space-x-4">
        <button className="flex hover:text-indigo-700" onClick={onStatusClick}>
          {estado === "completada" ? (
            <IconoCirculoTick className="inline h-5" />
          ) : (
            <IconoCirculo className="inline h-5" />
          )}
        </button>

        <span>{descricao}</span>
      </span>

      <button
        className={c("invisible transition-colors hover:text-indigo-700", {
          "group-hover:visible": !isAnyDragging && !isDragging,
        })}
        onClick={onRemover}
      >
        <IconoLixo className="h-5" />
      </button>
    </div>
  );
};

export default Tarefa;
