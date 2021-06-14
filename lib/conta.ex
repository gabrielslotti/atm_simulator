defmodule Conta do
  defstruct usuario: Usuario, saldo: 0
  @contas_file 'contas.txt'

  def cadastrar(usuario) do
    contas = busca_contas()

    case busca_contas_por_email(usuario.email) do
      nil ->
        binary = [%__MODULE__{usuario: usuario}] ++ contas
        |> :erlang.term_to_binary()
        File.write(@contas_file, binary)
      _ -> {:error, "Conta já cadastrada"}
    end
  end

  def busca_contas() do
    {:ok, binary} = File.read(@contas_file)
    binary |> :erlang.binary_to_term()
  end

  def busca_contas_por_email(email), do: Enum.find(busca_contas(), &(&1.usuario.email == email))

  def transferir(contas, de, para, valor) do
    de = busca_contas_por_email(de.usuario.email)

    cond do
      # TODO: Verificar se email existe para fazer a transferência
      valida_saldo(de.saldo, valor) -> {:error, "Saldo insuficiente"}
      true ->
        para = Enum.find(contas, fn conta -> conta.usuario.email == para.usuario.email end)
        de = %Conta{de | saldo: de.saldo - valor}
        para = %Conta{para | saldo: para.saldo + valor}
      [de, para]
    end
  end

  def sacar(conta, valor) do
    cond do
      valida_saldo(conta.saldo, valor) -> {:error, "Saldo insuficiente"}
      true ->
        conta = %Conta{conta | saldo: conta.saldo - valor}
        {:ok, conta}
    end
  end

  defp valida_saldo(saldo, valor), do: saldo < valor

end
