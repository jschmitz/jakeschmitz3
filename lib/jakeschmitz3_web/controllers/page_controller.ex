defmodule Jakeschmitz3Web.PageController do
  use Jakeschmitz3Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    IO.puts(_params["message"])
    response = send_message(_params["message"])
    IO.inspect(response)

    status_code = response[:status_code]

    if status_code == "202" do
      conn
      |> put_flash(:info, "Thank you for the message!")
      |> render("index.html")
    else
      conn
      |> put_flash(:error, "There was an error sending your message")
      |> render("index.html")
    end
  end

  defp send_message(message) do
    IO.puts("SENDING MESSAGE - #{message}")

    persy_account = System.get_env("PERSY_ACCOUNT")
    persy_token = System.get_env("PERSY_TOKEN")
    from_phone = System.get_env("FROM_PHONE")
    to_phone = System.get_env("TO_PHONE")

    :inets.start()
    :ssl.start()

    {:ok, {status, headers, body}} =
      :httpc.request(
        :post,
        {'https://www.freeclimb.com/apiserver/Accounts/#{persy_account}/Messages',
         [
           {'Authorization',
            'Basic ' ++ :base64.encode_to_string('#{persy_account}:#{persy_token}')}
         ], 'application/json',
         '{"to":"#{to_phone}", "from":"#{from_phone}", "text":"#{message}"}'},
        [],
        []
      )

    %{
      status_code: "#{elem(status, 1)}",
      request_id: "#{elem(List.keyfind(headers, 'x-pulse-request-id', 0), 1)}",
      text: "#{body}"
    }
  end
end
