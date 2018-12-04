defmodule Tz.Router do
  use Plug.Router

  if Mix.env() == :dev, do: use(Plug.Debugger)

  plug(:match)
  plug(:fetch_query_params)
  plug(:json_header)
  plug(:dispatch)

  get "/health" do
    send_resp(conn, 200, json(%{health: true}))
  end

  get "/now" do
    timezone = conn.params["timezone"] || "UTC"

    case Timex.now(timezone) do
      {:error, _} ->
        send_resp(conn, 400, json(%{error: true, message: "Unknown timezone '#{timezone}'"}))

      datetime ->
        send_resp(
          conn,
          200,
          json(%{
            datetime: datetime,
            timezone: timezone
          })
        )
    end
  end

  def json_header(conn, _opts) do
    put_resp_content_type(conn, "application/json")
  end

  def json(data), do: Jason.encode!(data)
end
