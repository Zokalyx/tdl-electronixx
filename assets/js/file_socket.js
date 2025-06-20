// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix"

// And connect to the path in "lib/tdl_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", { params: { token: window.userToken } })

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/tdl_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/tdl_web/components/layouts/root.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/tdl_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `file` and the
// subtopic is its id
const fileId = window.location.pathname.split("/").pop()
let channel = socket.channel("file:" + fileId, {})
let textarea = document.querySelector("#file-textarea")
let title = document.querySelector("#file-title")
let markdown_output = document.querySelector("#markdown-output")

const md = markdownit()

function update_markdown_output(content) {
  const result = md.render(content)
  markdown_output.innerHTML = result
}

// Interesting events
textarea.addEventListener("input", (event) => {
  channel.push("update", { content: event.target.value })
  update_markdown_output(event.target.value)
})
channel.on("update", (payload) => {
  textarea.value = payload.content
  update_markdown_output(payload.content)
})
channel.on("initial_content", (payload) => {
  textarea.value = payload.content
  title.textContent = payload.title
  update_markdown_output(payload.content)
})
channel.on("file_not_found", () => {
  console.error("File not found");
})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
