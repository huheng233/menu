defmodule MenuWeb.RecipeControllerTest do
  use MenuWeb.ConnCase

  alias Menu.Accounts
  alias Menu.Accounts.User

  @user_attrs %{
    email: "chenxsan@mail.com",
    username: "chehgnx",
    password: String.duplicate("1", 6)
  }

  @create_attrs %{
    content: "some content",
    episode: 42,
    name: "some name",
    season: 42,
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
    episode: 43,
    name: "some updated name",
    season: 43,
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, episode: nil, name: nil, season: nil, title: nil}

  def create_attrs do
    user = Repo.insert!(User.changeset(%User{}, @user_attrs))
    create_attrs = Map.put(@create_attrs, :user_id, user.id)
  end

  def fixture(:recipe) do
    create_attrs = create_attrs()
    {:ok, recipe} = Accounts.create_recipe(create_attrs)
    recipe
  end

  # defp create_recipe(_) do
  #   recipe = fixture(:recipe)
  #   {:ok, [recipe: recipe]}
  # end

  setup %{conn: conn} = context do
    recipe = fixture(:recipe)

    if context[:logged_in] == true do
      conn = post(conn, session_path(conn, :create), session: @user_attrs)
      {:ok, [conn: conn, recipe: recipe]}
    else
      {:ok, [recipe: recipe]}
    end
  end

  describe "index" do
    @tag logged_in: true
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, recipe_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Recipes"
    end
  end

  describe "new recipe" do
    @tag logged_in: true
    test "renders form", %{conn: conn} do
      conn = get(conn, recipe_path(conn, :new))
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  @tag logged_in: true
  describe "create recipe" do
    test "redirects to show when data is valid", %{conn: conn, recipe: recipe} do
      conn = get(conn, recipe_path(conn, :show, recipe.id))
      assert html_response(conn, 200) =~ "Show Recipe"
    end

    @tag logged_in: true
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, recipe_path(conn, :create), recipe: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "edit recipe" do
    # setup [:create_recipe]
    @tag logged_in: true
    test "renders form for editing chosen recipe", %{conn: conn, recipe: recipe} do
      conn = get(conn, recipe_path(conn, :edit, recipe))
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    # setup [:create_recipe]
    @tag logged_in: true
    test "redirects when data is valid", %{conn: conn, recipe: recipe} do
      conn = put(conn, recipe_path(conn, :update, recipe), recipe: @update_attrs)
      assert redirected_to(conn) == recipe_path(conn, :show, recipe)

      conn = get(conn, recipe_path(conn, :show, recipe))
      assert html_response(conn, 200) =~ "some updated content"
    end

    @tag logged_in: true
    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put(conn, recipe_path(conn, :update, recipe), recipe: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "delete recipe" do
    # setup [:create_recipe]
    @tag logged_in: true
    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete(conn, recipe_path(conn, :delete, recipe))
      assert redirected_to(conn) == recipe_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, recipe_path(conn, :show, recipe))
      end)
    end
  end
end
