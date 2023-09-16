defmodule WhenisthatformeRecurse.Router do
  use Plug.Router

  plug(:match)
  plug(Teleplug)
  plug(:dispatch)

  get "/" do
    send_resp(
      conn,
      200,
      EEx.eval_string("""
      <!DOCTYPE html>
      <html lang="en">
      <head>
      <meta charset="utf-8" />
      <meta http-equiv="x-ua-compatible" content="ie=edge, chrome=1" />
      <title>untitled</title>
      </head>
      <body>
      <form action="/e" method="get">


       <label for="dt">Birthday (date and time):</label>
      <input type="datetime-local" id="dt" name="dt"> 
      <select name="tz" id="tz">
        <option value="" disabled>Select a Timezone</option>
        <%= for timezone <- TzExtra.time_zone_identifiers() do %>
        <option value="<%= timezone %>"><%= timezone %></option>
        <% end %>
      </select>
      <button type="submit">Send your message</button>
      </form>
      </body>
      </html>
      """)
    )
  end

  get "/e" do
    conn = fetch_query_params(conn)

    case parse_date(conn.params) do
      {:ok, datetime} ->
        guest_tz = IO.inspect(Map.get(conn.params, "guest_tz", conn.params["tz"])) |> URI.decode()
        {:ok, datetime} = DateTime.shift_zone(datetime, guest_tz, Tz.TimeZoneDatabase)

        send_resp(
          conn,
          200,
          EEx.eval_string(
            """
            <!DOCTYPE html>
            <html lang="en">
            <head>
            <meta charset="utf-8" />
            <meta http-equiv="x-ua-compatible" content="ie=edge, chrome=1" />
            <title>untitled</title>
            </head>
            <body>
            <%= @datetime %>
            <form action="/e" method="get">


            <select name="guest_tz" id="guest_tz">
              <option value="Etc/UTC" disabled>Select a Timezone</option>
              <%= for timezone <- TzExtra.time_zone_identifiers() do %>
            <%= if not is_nil(@params["guest_tz"]) and timezone == URI.decode(@params["guest_tz"]) do %>
              <option value="<%= timezone %>" selected><%= timezone %></option>
            <% else %>
              <option value="<%= timezone %>"><%= timezone %></option>
            <% end %>
              <% end %>
            </select>
            <input type="hidden" id="tz" name="tz" value="<%= @params["tz"] %>">
            <input type="hidden" id="dt" name="dt" value="<%= @params["dt"] %>">
            <button type="submit">Send your message</button>
            </form>
            </body>
            </html>
            """,
            assigns: [datetime: datetime, params: conn.params]
          )
        )

      {:error, :invalid_format} ->
        send_resp(conn, 400, "invalid datetime format")

      {:error, :time_zone_not_found} ->
        send_resp(conn, 400, "invalid timezone")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp parse_date(params) do
    timezone = Map.get(params, "tz", "Etc/UTC")
    datetime = Map.get(params, "dt", NaiveDateTime.utc_now())

    with {:ok, naive_date_time} <- NaiveDateTime.from_iso8601(URI.decode(datetime) <> ":00"),
         {:ok, datetime} <-
           DateTime.from_naive(naive_date_time, URI.decode(timezone), Tz.TimeZoneDatabase) do
      {:ok, datetime}
    end
  end
end
