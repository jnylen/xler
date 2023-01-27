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

  @doc """
  Parses a specific worksheet from a file

  Returns an list (of rows) with a list of columns

  ## Examples

      iex> Xler.parse("file.xls", "Sheet 1")
      {:ok, [["Date", "Text"]]}

  """
  def parse(filename, worksheet, opts \\ [])
      when is_binary(filename) and is_binary(worksheet) and is_list(opts) do
    filename
    |> Native.parse(worksheet)
    |> convert_data_types(opts)
  end

  defp convert_data_types({:ok, data}, opts) do
    format_opts = Keyword.get(opts, :format, %{})

    data
    |> Enum.with_index()
    |> Enum.map(fn
      {row, 0} ->
        if Map.get(format_opts, :skip_headers, true) == true do
          row
        else
          format_cells(row, Map.get(format_opts, :columns, []))
        end

      {row, _index} ->
        format_cells(row, Map.get(format_opts, :columns, []))
    end)
    |> then(&{:ok, &1})
  end

  defp format_cells(row, columns_opts) do
    opts = Map.new(columns_opts, &{&1.column, &1.data_type})

    row
    |> Enum.with_index()
    |> Enum.map(fn {cell, index} ->
      format_cell(cell, Map.get(opts, index))
    end)
  end

  defp format_cell(cell, :integer) do
    case Integer.parse(cell) do
      {value, _rest} -> value
      :error -> cell
    end
  end

  defp format_cell(cell, :float) do
    case Float.parse(cell) do
      {value, _rest} -> value
      :error -> cell
    end
  end

  defp format_cell(cell, :boolean) do
    case cell do
      "1" -> true
      "0" -> false
      _other -> cell
    end
  end

  @day_in_seconds 86400
  defp format_cell(cell, :datetime) do
    case Float.parse(cell) do
      {time, _rest} ->
        NaiveDateTime.add(
          ~N[1900-01-01 00:00:00],
          round(time * @day_in_seconds) - 2 * @day_in_seconds
        )

      :error ->
        cell
    end
  end

  defp format_cell(cell, :date) do
    case format_cell(cell, :datetime) do
      %NaiveDateTime{} = datetime -> NaiveDateTime.to_date(datetime)
      other -> other
    end
  end

  defp format_cell(cell, :time) do
    case format_cell(cell, :datetime) do
      %NaiveDateTime{} = datetime -> NaiveDateTime.to_time(datetime)
      other -> other
    end
  end

  defp format_cell(cell, _), do: cell
end
