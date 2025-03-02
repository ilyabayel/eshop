require Protocol

Protocol.derive(Jason.Encoder, Money)

defimpl Jason.Encoder, for: Decimal do
  def encode(decimal, _opts) do
    Decimal.to_string(decimal, :raw)
  end
end
