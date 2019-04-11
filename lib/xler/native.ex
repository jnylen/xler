defmodule Xler.Native do
  use Rustler, otp_app: :xler, crate: :xler_native

  def parse(_filename, _worksheet), do: error()
  def worksheets(_filename), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
