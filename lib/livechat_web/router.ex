defmodule LivechatWeb.Router do
  use LivechatWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Phoenix.LiveView.Flash)
    plug(:assign_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", LivechatWeb do
    pipe_through(:browser)

    get("/", ChatController, :index)
  end

  scope "/auth", LivechatWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :index)
    get("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivechatWeb do
  #   pipe_through :api
  # end
end
