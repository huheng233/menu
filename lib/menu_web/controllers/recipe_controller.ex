defmodule MenuWeb.RecipeController do
  use MenuWeb, :controller

  alias Menu.Accounts
  alias Menu.Accounts.Recipe

  def index(conn, _params) do
    recipes = Accounts.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Accounts.change_recipe(%Recipe{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    case Accounts.create_recipe(recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Accounts.get_recipe!(id)
    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Accounts.get_recipe!(id)
    changeset = Accounts.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Accounts.get_recipe!(id)

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
    recipe = Accounts.get_recipe!(id)
    {:ok, _recipe} = Accounts.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: recipe_path(conn, :index))
  end
end
