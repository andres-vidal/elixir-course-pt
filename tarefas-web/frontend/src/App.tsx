import { FC } from "react";
import Tarefas from "./Tarefas";

const App: FC = () => {
  return (
    <div className="h-full p-20">
      <h1 className="py-4 text-xl text-center font-base">
        Minha lista de tarefas
      </h1>
      <main className="flex justify-center h-full ">
        <Tarefas />
      </main>
    </div>
  );
};

export default App;
