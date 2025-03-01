defmodule Eshop.ExMachinaPolymorphicEmbed.Ecto do
  @moduledoc """
  `ExMachina.Ecto` replacement that supports `PolymorphicEmbed`.

  Minor modification of https://github.com/bitfreighter/ex_machina_polymorphic_embed
  """

  defmacro __using__(opts) do
    quote do
      use ExMachina
      use Eshop.ExMachinaPolymorphicEmbed.EctoStrategy, unquote(opts)

      def params_for(factory_name, attrs \\ %{}) do
        ExMachina.Ecto.params_for(__MODULE__, factory_name, attrs)
      end

      def string_params_for(factory_name, attrs \\ %{}) do
        ExMachina.Ecto.string_params_for(__MODULE__, factory_name, attrs)
      end

      def params_with_assocs(factory_name, attrs \\ %{}) do
        ExMachina.Ecto.params_with_assocs(__MODULE__, factory_name, attrs)
      end

      def string_params_with_assocs(factory_name, attrs \\ %{}) do
        ExMachina.Ecto.string_params_with_assocs(__MODULE__, factory_name, attrs)
      end
    end
  end
end
