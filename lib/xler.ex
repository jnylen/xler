defmodule Xler do
  alias Xler.Native

  @moduledoc """
  Documentation for Xler.
  """

  @doc """
  Show the available worksheets for file.

  ## Examples

      iex> Xler.worksheets("file.xls")
      {:ok, ["Sheet 1"]}

  """
  def worksheets(filename) when is_binary(filename), do: filename |> Native.worksheets()
  def worksheets(_), do: {:error, "not a string"}

  @doc """
  Parses a specific worksheet from a file

  Returns an list (of rows) with a list of columns

  ## Examples

      iex> Xler.parse("file.xls", "Sheet 1")
      {:ok, [["Date", "Text"]]}

  """
  def parse(filename, worksheet) when is_binary(filename) and is_binary(worksheet),
    do: filename |> Native.parse(worksheet)

  def worksheets(_, _), do: {:error, "not a string"}
end
