# Xler

Xler uses the Calamine Rust library to get contents of Excel files.

**Calamine supports:**

- excel (xls, xlsx, xlsm, xlsb, xla, xlam)
- opendocument spreadsheets (ods)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `xler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xler, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/xler](https://hexdocs.pm/xler).

## Worksheets

To get the worksheets of a file you use:

```elixir
Xler.worksheets("filename.xls")
```

and it will return as a tuple:

```elixir
{:ok, ["Sheet 1"]}
```

## Parse

To get the data of a worksheet you use:

```elixir
Xler.parse("filename.xls", "Sheet 1")
```

and it will return as a tuple:

```elixir
{:ok, [["Date", "Time"]]}
```
