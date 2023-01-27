defmodule XlerTest do
  use ExUnit.Case, async: true

  @fixture Path.join(__DIR__, "/data/example2.xlsx")

  describe "worksheets/1" do
    test "can read worksheets from xlsx file" do
      assert Xler.worksheets(@fixture) == {:ok, ["Sheet1"]}
    end

    test "file not found"

    test "file is not a sheet"
  end

  describe "parse/3" do
    test "parses a sheet and data types" do
      assert {:ok, data} =
               Xler.parse(@fixture, "Sheet1",
                 format: %{
                   skip_headers: true,
                   columns: [
                     %{column: 0, data_type: :integer},
                     %{column: 1, data_type: :float},
                     %{column: 3, data_type: :boolean},
                     %{column: 4, data_type: :date},
                     %{column: 5, data_type: :time},
                     %{column: 6, data_type: :datetime}
                   ]
                 }
               )

      assert data == [
               ["Int", "Float", "String", "Bool", "Date", "Time", "DateTime", "Empty"],
               [
                 10,
                 20.12,
                 "text",
                 true,
                 ~D[2022-01-30],
                 ~T[09:51:00],
                 ~N[2022-01-30 09:51:00],
                 ""
               ]
             ]
    end

    test "worksheet not found"
    test "file not found"
    test "file is not a sheet"
  end
end
