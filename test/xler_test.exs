defmodule XlerTest do
  use ExUnit.Case
  # doctest Xler

  def file(), do: File.cwd!() <> "/test/data/sample.xlsx"

  test "can read worksheets from xlsx file" do
    assert Xler.worksheets(file()) == {:ok, ["Sheet1"]}
  end

  test "gets a list of data returned via the worksheet name" do
    {:ok, data} = Xler.parse(file(), "Sheet1")

    assert length(data) == 701
  end

  test "returns the correct first row" do
    {:ok, data} = Xler.parse(file(), "Sheet1")

    assert data |> List.first() == [
             "Segment",
             "Country",
             "Product",
             "Discount Band",
             "Units Sold",
             "Manufacturing Price",
             "Sale Price",
             "Gross Sales",
             "Discounts",
             " Sales",
             "COGS",
             "Profit",
             "Date",
             "Month Number",
             "Month Name",
             "Year"
           ]
  end
end
