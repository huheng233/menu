defmodule Menu.AccountsTest do
  use Menu.DataCase
  # use Menu.ModelCase
  @moduletag :accounts

  alias Menu.Accounts
  alias Menu.Accounts.User

  describe "users" do
    alias Menu.Accounts.User

    @valid_attrs %{email: "some@email", password: "somepassword", username: "someusername"}
    @update_attrs %{
      email: "updated@email",
      password: "someupdatedpassword",
      username: "updatedusername"
    }
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [Map.put(user, :password, nil)]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == Map.put(user, :password, nil)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.password == @valid_attrs.password
      assert user.username == @valid_attrs.username
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == @update_attrs.email
      assert user.password == @update_attrs.password
      assert user.username == @update_attrs.username
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert Map.put(user, :password, nil) == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "recipes" do
    alias Menu.Accounts.Recipe

    @valid_attrs %{
      content: "some content",
      episode: 42,
      name: "some name",
      season: 42,
      title: "some title",
      user_id: 1
    }
    @update_attrs %{
      content: "some updated content",
      episode: 43,
      name: "some updated name",
      season: 43,
      title: "some updated title"
    }
    @invalid_attrs %{content: nil, episode: nil, name: nil, season: nil, title: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_recipe()

      recipe
    end

    setup do
      user_attrs = %{
        email: "chenxsan@gmail.com",
        username: "chenxsan",
        password: String.duplicate("1", 6)
      }

      user = Repo.insert!(User.changeset(%User{}, user_attrs))

      attrs = Map.put(@valid_attrs, :user_id, user.id)
      {:ok, [attrs: attrs]}
    end

    test "list_recipes/0 returns all recipes", %{attrs: attrs} do
      recipe = recipe_fixture(attrs)
      assert Accounts.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id", %{attrs: attrs} do
      recipe = recipe_fixture(attrs)
      assert Accounts.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe", %{attrs: attrs} do
      assert {:ok, %Recipe{} = recipe} = Accounts.create_recipe(attrs)
      assert recipe.content == "some content"
      assert recipe.episode == 42
      assert recipe.name == "some name"
      assert recipe.season == 42
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe", %{attrs: attrs} do
      recipe = recipe_fixture(attrs)
      assert {:ok, recipe} = Accounts.update_recipe(recipe, @update_attrs)
      assert %Recipe{} = recipe
      assert recipe.content == "some updated content"
      assert recipe.episode == 43
      assert recipe.name == "some updated name"
      assert recipe.season == 43
      assert recipe.title == "some updated title"
    end

    test "update_recipe/2 with invalid data returns error changeset", %{attrs: attrs} do
      recipe = recipe_fixture(attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_recipe(recipe, @invalid_attrs)
      assert recipe == Accounts.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe", %{attrs: attrs} do
      recipe = recipe_fixture(attrs)
      assert {:ok, %Recipe{}} = Accounts.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset", %{attrs: attrs} do
      recipe = recipe_fixture(attrs)
      assert %Ecto.Changeset{} = Accounts.change_recipe(recipe)
    end

    test "name is required" do
      attrs = %{@valid_attrs | name: ""}
      assert {:name, "请填写"} in errors_on(%Recipe{}, attrs)
    end

    test "title is required" do
      attrs = %{@valid_attrs | title: ""}
      assert {:title, "请填写"} in errors_on(%Recipe{}, attrs)
    end

    test "season is required" do
      attrs = %{@valid_attrs | season: nil}
      assert {:season, "请填写"} in errors_on(%Recipe{}, attrs)
    end

    test "episode is required" do
      attrs = %{@valid_attrs | episode: nil}
      assert {:episode, "请填写"} in errors_on(%Recipe{}, attrs)
    end

    test "season should greater than 0" do
      attrs = %{@valid_attrs | season: 0}
      assert {:season, "请输入大于 0 的数字"} in errors_on(%Recipe{}, attrs)
    end

    test "episode should greater than 0" do
      attrs = %{@valid_attrs | episode: 0}
      assert {:episode, "请输入大于 0 的数字"} in errors_on(%Recipe{}, attrs)
    end

    test "content is required" do
      attrs = %{@valid_attrs | content: ""}
      assert {:content, "请填写"} in errors_on(%Recipe{}, attrs)
    end
  end
end
