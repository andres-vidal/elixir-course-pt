defmodule TarefasWeb.Router do
  use TarefasWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TarefasWeb do
    pipe_through(:api)
  end
end
