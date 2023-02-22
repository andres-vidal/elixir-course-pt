import Tarefa from "./Tarefa";

const BACKEND_API_URL = "http://localhost:4000/api";

const Backend = {
  async tarefas() {
    const resp = await fetch(`${BACKEND_API_URL}/tarefas`);
    const json = await resp.json();
    return json as Tarefa[];
  },

  criar(descricao: string) {
    return fetch("http://localhost:4000/api/tarefas", {
      method: "POST",
      body: JSON.stringify({ descricao }),
      headers: { "Content-Type": "application/json" },
    });
  },

  mover(origem: number, destino: number) {
    return fetch(`${BACKEND_API_URL}/tarefas/${origem}/mover-a/${destino}`, {
      method: "POST",
    });
  },

  remover(posicao: number) {
    return fetch(`${BACKEND_API_URL}/tarefas/${posicao}`, {
      method: "DELETE",
    });
  },

  completar(posicao: number) {
    return fetch(`${BACKEND_API_URL}/tarefas/completadas/${posicao}`, {
      method: "POST",
    });
  },

  reiniciar(posicao: number) {
    return fetch(`${BACKEND_API_URL}/tarefas/completadas/${posicao}`, {
      method: "DELETE",
    });
  },
};

export { Backend };
