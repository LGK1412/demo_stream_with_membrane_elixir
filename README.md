# Demo

To start your Phoenix server:

  * If you use window install WSL (Windows Subsystem for Linux) and install Ubuntu ask chatGPT if you don't know then clone this repo in WSL. Use WSL to run.
  * Run `mix deps.get` to install and setup dependencies then run `mix compile` any error go ask chatGPT.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

* NOTICE:
- Open OBS then go setting -> Stream -> Service -> Custom -> Server -> rtmp://localhost:9006 -> Stream key -> hehe.
- If you want to change stream key go lib/demo/application.ex. If you want to change server I don't know.
- When you start a new stream all old stream will be delete If you want to change go to lib/demo/application.ex
- Go to Membrane website to learn more.

Vietnamese version: 

Hướng dẫn khởi động Phoenix server:
   * Nếu bạn dùng Windows, hãy cài đặt WSL (Windows Subsystem for Linux) và Ubuntu. Nếu không biết cách cài, hãy hỏi ChatGPT. Sau đó, clone repo này vào WSL và chạy trong WSL.
   * Chạy lệnh mix deps.get để cài đặt và thiết lập các dependencies, sau đó chạy mix compile. Nếu gặp lỗi, hãy hỏi ChatGPT.
   * Khởi động Phoenix server bằng lệnh mix phx.server hoặc chạy trong IEx với iex -S mix phx.server.
   * Bây giờ, bạn có thể truy cập localhost:4000 trên trình duyệt.

Lưu ý:
   - Mở OBS, vào Cài đặt → Stream →
   - Service: Chọn Custom
   - Server: Nhập rtmp://localhost:9006
   - Stream Key: Nhập hehe
   - Nếu muốn đổi Stream Key, hãy vào file lib/demo/application.ex.
   - Khi bắt đầu stream mới, toàn bộ dữ liệu stream cũ sẽ bị xóa. Nếu muốn thay đổi, hãy sửa trong lib/demo/application.ex.
   - Để tìm hiểu thêm về Membrane, hãy truy cập trang web của họ.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
# demo_stream_with_membrane_elixir
