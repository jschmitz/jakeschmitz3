defmodule Jakeschmitz3Web.PageController do
  use Jakeschmitz3Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
