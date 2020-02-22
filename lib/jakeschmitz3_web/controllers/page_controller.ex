defmodule Jakeschmitz3Web.PageController do
  use Jakeschmitz3Web, :controller

  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    response = send_message(_params["message"])
    status_code = response[:status_code]

    if status_code == "202" do
      Logger.info("The text message was sent successfully #{inspect(response)}")

      conn
      |> put_flash(:info, "Thank you for the message!")
      |> render("index.html")
    else
      Logger.error(
        "There was an error sending the text message using FreeClimb. FreeClimb response was #{
          inspect(response)
        }"
      )

      conn
      |> put_flash(:error, "There was an error sending your message.")
      |> render("index.html")
    end
  end

  defp send_message(message) do
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
      request_id: request_id(headers, "#{elem(status, 1)}"),
      text: "#{body}"
    }
  end

  defp request_id(headers, status_code) do
    if status_code == "202" do
      "#{elem(List.keyfind(headers, 'x-pulse-request-id', 0), 1)}"
    else
      ""
    end
  end
end
