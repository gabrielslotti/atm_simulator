defmodule Usuario do
  defstruct nome: nil, email: nil
  def novo(nome, email) do
    %__MODULE__{nome: nome, email: email} #  __MODULE__ == Usuario
  end
end
