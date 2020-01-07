defmodule Jakeschmitz3Web.PageControllerTest do
  use Jakeschmitz3Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hello"
  end

  test "POST /", %{conn: conn} do
    conn = post(conn, "/")
    assert html_response(conn, 200) =~ "Hello"
  end
end
