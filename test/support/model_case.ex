defmodule Menu.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.

  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Menu.Repo
      import Ecto
      # import Ecto.Model
      import Ecto.Query
      import Menu.ModelCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Menu.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Menu.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  Helper for returning list of errors in model when passed certain data.

  ## Examples

  Given a User model that lists `:name` as a required field and validates
  `:password` to be safe, it would return:

      iex> errors_on(%User{}, %{password: "password"})
      [password: "is unsafe", name: "is blank"]

  You could then write your assertion like:

      assert {:password, "is unsafe"} in errors_on(%User{}, %{password: "password"})

  You can also create the changeset manually and retrieve the errors
  field directly:

      iex> changeset = User.changeset(%User{}, password: "password")
      iex> {:password, "is unsafe"} in changeset.errors
      true
  """

  # def errors_on(changeset) do
  #   Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
  #     Enum.reduce(opts, message, fn {key, value}, acc ->
  #       String.replace(acc, "%{#{key}}", to_string(value))
  #     end)
  #   end)
  # end
  def errors_on(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&MenuWeb.ErrorHelpers.translate_error/1)
    |> Enum.flat_map(fn {key, errors} -> for msg <- errors, do: {key, msg} end)
  end

  @spec errors_on(atom | %{__struct__: atom}, any) :: [any]
  def errors_on(struct, data) do
    struct.__struct__.changeset(struct, data)
    |> errors_on
  end
end
