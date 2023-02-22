import { FC, useEffect, useState } from "react";
import Tarefa from "./Tarefa";
import TarefaNova from "./TarefaNova";
import c from "classnames";
import { useQuery } from "react-query";
import { Reorder } from "framer-motion";
import { range } from "lodash";
import { Backend } from "./backend";

const Tarefas: FC = () => {
  const [isFocused, setIsFocused] = useState(false);

  const { data = [], refetch } = useQuery({
    queryKey: ["tarefas"],
    queryFn: Backend.tarefas,
    refetchOnMount: true,
    refetchOnWindowFocus: true,
  });

  const [order, setOrder] = useState(range(data.length));

  useEffect(() => setOrder(range(data.length)), [JSON.stringify(data)]);

  const [draggedItem, setDraggedItem] = useState<number | undefined>(undefined);

  const draggedId =
    draggedItem !== undefined ? data[draggedItem].id : undefined;

  const isOrderValid = order.length === data.length;

  return isOrderValid ? (
    <div className="flex-1 space-y-1">
      <Reorder.Group
        values={order}
        onReorder={setOrder}
        className="drop-shadow"
      >
        {order.map((indice) => (
          <Reorder.Item
            key={data[indice].id}
            value={indice}
            className="relative overflow-hidden first:rounded-t"
            onDragStart={() => setDraggedItem(indice)}
            onDragEnd={async () => {
              await Backend.mover(indice, order.indexOf(indice));
              setDraggedItem(undefined);
              setOrder(range(data.length));
              refetch();
            }}
          >
            <Tarefa
              {...data[indice]}
              draggedId={draggedId}
              onRemover={async () => {
                await Backend.remover(indice);
                refetch();
              }}
              onStatusClick={async () => {
                if (data[indice].estado === "sem_completar") {
                  await Backend.completar(indice);
                  refetch();
                } else {
                  await Backend.reiniciar(indice);
                  refetch();
                }
              }}
            />
          </Reorder.Item>
        ))}

        <li className="overflow-hidden rounded-b first:rounded-t">
          <TarefaNova
            onFocus={() => setIsFocused(true)}
            onBlur={() => setIsFocused(false)}
          />
        </li>
      </Reorder.Group>

      <div
        className={c("italic text-xs px-1 text-right", {
          invisible: !isFocused,
        })}
      >
        Pressione <strong className="font-bold text-indigo-700">ENTER</strong>{" "}
        para criar a nova tarefa
      </div>
    </div>
  ) : (
    <>Carregando...</>
  );
};

export default Tarefas;
