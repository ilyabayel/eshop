defmodule Eshop.Repo do
  use Ecto.Repo,
    otp_app: :eshop,
    adapter: Ecto.Adapters.Postgres

  @spec fetch(Ecto.Queryable.t(), term()) :: {:ok, term()} | {:error, :not_found}
  @spec fetch(Ecto.Queryable.t(), term(), keyword()) :: {:ok, term()} | {:error, :not_found}
  def fetch(queryable, id, opts \\ []) do
    case Eshop.Repo.get(queryable, id, opts) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @spec fetch_by(Ecto.Queryable.t(), keyword() | map()) :: {:ok, term()} | {:error, :not_found}
  @spec fetch_by(Ecto.Queryable.t(), keyword() | map(), keyword()) :: {:ok, term()} | {:error, :not_found}
  def fetch_by(queryable, clauses, opts \\ []) do
    case Eshop.Repo.get_by(queryable, clauses, opts) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end
end
