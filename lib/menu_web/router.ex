defmodule MenuWeb.Router do
  use MenuWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(MenuWeb.Auth, repo: Menu.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MenuWeb do
    # Use the default browser stack
    pipe_through(:browser)

    # 用户增删该查
    get("/users", UserController, :index)
    get("/users/:id/edit", UserController, :edit)
    get("/users/new", UserController, :new)
    get("/users/:id", UserController, :show)
    post("/users", UserController, :create)
    patch("/users/:id", UserController, :update)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)

    # 用户登录
    get("/sessions/new", SessionController, :new)
    post("/sessions/new", SessionController, :create)
    delete("/session/:id", SessionController, :delete)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", MenuWeb do
  #   pipe_through :api
  # end
end
