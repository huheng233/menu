defmodule MenuWeb.RecipeController do
  use MenuWeb, :controller
  plug(:login_require)
  alias Menu.Repo
  alias Menu.Accounts
  alias Menu.Accounts.Recipe
  import Ecto

  def index(conn, _params) do
    recipes =
      assoc(conn.assigns.current_user, :recipes)
      |> Accounts.list_recipes()

    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:recipes)
      |> Recipe.changeset(%{})

    # |> Accounts.change_recipe()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:recipes)
      |> Recipe.changeset(recipe_params)

    # case Accounts.create_recipe(recipe_params) do
    case Repo.insert(changeset) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe =
      assoc(conn.assigns.current_user, :recipes)
      |> Accounts.get_recipe!(id)

    # recipe = assoc(conn.assigns.current_user, :recipes) |> Repo.get!(id)
    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe =
      assoc(conn.assigns.current_user, :recipes)
      |> Accounts.get_recipe!(id)

    changeset = Accounts.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe =
      assoc(conn.assigns.current_user, :recipes)
      |> Accounts.get_recipe!(id)

    case Accounts.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: recipe_path(conn, :show, recipe))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # user_recipe = assoc(conn.assigns.current_user, :recipe)
    # recipe = Accounts.get_recipe!(user_recipe, id)
    # {:ok, _recipe} = Accounts.delete_recipe(recipe)
    recipe = assoc(conn.assigns.current_user, :recipes) |> Repo.get!(id)
    {:ok, _recipe} = Repo.delete(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: recipe_path(conn, :index))
  end
end
