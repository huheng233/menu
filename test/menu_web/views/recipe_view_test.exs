defmodule MenuWeb.RecipeViewTest do
  use MenuWeb.ConnCase, async: true
  import Phoenix.View
  alias Menu.Accounts.Recipe
  alias MenuWeb.RecipeView

  test "render index.html", %{conn: conn} do
    recipes = [
      %Recipe{
        id: "1",
        name: "erdan",
        title: "而但",
        season: "1",
        episode: "1",
        content: "haahahha",
        user_id: "999"
      },
      %Recipe{
        id: "2",
        name: "煮饭",
        title: "侠饭",
        season: "1",
        episode: "1",
        content: "浸泡",
        user_id: "888"
      }
    ]

    content = render_to_string(RecipeView, "index.html", conn: conn, recipes: recipes)
    assert String.contains?(content, "Listing Recipes")

    for recipe <- recipes do
      assert String.contains?(content, recipe.name)
      assert String.contains?(content, recipe.title)
      assert String.contains?(content, recipe.season)
      assert String.contains?(content, recipe.episode)
      refute String.contains?(content, recipe.user_id)
      refute String.contains?(content, recipe.content)
    end
  end

  test "render new.html", %{conn: conn} do
    changeset = Recipe.changeset(%Recipe{}, %{})
    content = render_to_string(RecipeView, "new.html", conn: conn, changeset: changeset)
    assert String.contains?(content, "url")
  end

  test "render show.html", %{conn: conn} do
    recipe = %Recipe{
      id: "1",
      name: "淘米",
      title: "侠饭",
      season: "1",
      episode: "1",
      content: "洗掉米表面的淀粉",
      user_id: "999",
      url: "https://github.com/chenxsan/PhoenixFramework"
    }

    content = render_to_string(RecipeView, "show.html", conn: conn, recipe: recipe)
    assert String.contains?(content, recipe.url)
  end

  test "render edit.html", %{conn: conn} do
    recipe = %Recipe{
      id: "1",
      name: "淘米",
      title: "侠饭",
      season: "1",
      episode: "1",
      content: "洗掉米表面的淀粉",
      user_id: "999",
      url: "https://github.com/chenxsan/PhoenixFramework"
    }

    changeset =
      Recipe.changeset(%Recipe{}, %{
        id: "1",
        name: "淘米",
        title: "侠饭",
        season: "1",
        episode: "1",
        content: "洗掉米表面的淀粉",
        user_id: "999",
        url: "https://github.com/chenxsan/PhoenixFramework"
      })

    content =
      render_to_string(RecipeView, "edit.html", conn: conn, changeset: changeset, recipe: recipe)

    assert String.contains?(content, recipe.url)
  end
end
