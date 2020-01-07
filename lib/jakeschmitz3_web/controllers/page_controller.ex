defmodule Jakeschmitz3Web.PageController do
  use Jakeschmitz3Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    IO.puts(_params["message"])
    send_message(_params["message"])

    render(conn, "index.html")
  end

  defp send_message(message) do
    persy_account = System.get_env("PERSY_ACCOUNT")
    persy_token = System.get_env("PERSY_TOKEN")
    from_phone = System.get_env("FROM_PHONE")
    to_phone = System.get_env("TO_PHONE")

    :inets.start()
    :ssl.start()

    {:ok, {_status, _headers, body}} =
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
      text: "#{body}"
    }
  end
end
