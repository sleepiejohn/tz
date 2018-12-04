defmodule Tz.RouterTest do
  use ExUnit.Case
  use Plug.Test
  alias Tz.Router

  @opts Router.init([])

  test "GET /health should return whenever the service is healthy" do
    conn =
      conn(:get, "/health")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == Jason.encode!(%{health: true})
  end

  describe("GET /now") do
    test "should return the current time at UTC" do
      conn = conn(:get, "/now") |> Router.call(@opts)
      assert conn.state == :sent
      assert conn.status == 200
      body = Jason.decode!(conn.resp_body)
      refute body["error"]
      assert body["timezone"] == "UTC"
      assert is_binary(body["datetime"])
    end

    test "with timezone parameter should return time at that timezone" do
      conn = conn(:get, "/now", %{timezone: "America/Sao_Paulo"}) |> Router.call(@opts)
      assert conn.state == :sent
      assert conn.status == 200
      body = Jason.decode!(conn.resp_body)
      refute body["error"]
      assert body["timezone"] == "America/Sao_Paulo"
      assert is_binary(body["datetime"])
    end

    test "with incorret timezone should return error message" do
      conn = conn(:get, "/now", %{timezone: "US"}) |> Router.call(@opts)
      assert conn.state == :sent
      assert conn.status == 400
      body = Jason.decode!(conn.resp_body)
      assert body["error"]
      assert body["message"] =~ "Unknown timezone 'US'"
    end
  end
end
