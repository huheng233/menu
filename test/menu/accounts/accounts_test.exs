defmodule Menu.AccountsTest do
  use Menu.DataCase

  @moduletag :accounts

  alias Menu.Accounts

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

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Accounts.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Accounts.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Accounts.create_recipe(@valid_attrs)
      assert recipe.content == "some content"
      assert recipe.episode == 42
      assert recipe.name == "some name"
      assert recipe.season == 42
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, recipe} = Accounts.update_recipe(recipe, @update_attrs)
      assert %Recipe{} = recipe
      assert recipe.content == "some updated content"
      assert recipe.episode == 43
      assert recipe.name == "some updated name"
      assert recipe.season == 43
      assert recipe.title == "some updated title"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_recipe(recipe, @invalid_attrs)
      assert recipe == Accounts.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Accounts.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Accounts.change_recipe(recipe)
    end
  end
end
