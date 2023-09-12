defmodule WhenisthatformeRecurse.Router do
  use Plug.Router

  plug :match
  plug Teleplug
  plug :dispatch

  get "/hello" do
    IO.inspect fetch_query_params(conn)
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

end

