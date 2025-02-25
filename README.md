# Demo

To start your Phoenix server:

  * If you use window install WSL (Windows Subsystem for Linux) and install Ubuntu ask chatGPT if you don't know then clone this repo in WSL. Use WSL to run.
  * Run `mix deps.get` to install and setup dependencies then run `mix compile` any error go ask chatGPT.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Go to Cloudinary make an account to get API then go to dev.exs.
  * Change config your repo. Run `mix ecto.create` and i don't know just make sure your database can run.
  
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

* NOTICE:
- Open OBS then go setting -> Stream -> Service -> Custom -> Server -> rtmp://localhost:9006 -> Stream key -> hehe.
- If you want to change stream key go lib/demo/application.ex. If you want to change server I don't know.
- When you start a new stream all old stream will be delete If you want to change go to lib/demo/application.ex
- Go to Membrane website to learn more.
- When you stream go to custom stream page click ok to stream
- Click button "Chuyển đổi và tải video" to download video them wait for button "Tải video stream" to download video ok

Vietnamese version: 

Hướng dẫn khởi động Phoenix server:
   * Nếu bạn dùng Windows, hãy cài đặt WSL (Windows Subsystem for Linux) và Ubuntu. Nếu không biết cách cài, hãy hỏi ChatGPT. Sau đó, clone repo này vào WSL và chạy trong WSL.
   * Chạy lệnh `mix deps.get` để cài đặt và thiết lập các dependencies, sau đó chạy `mix compile`. Nếu gặp lỗi, hãy hỏi ChatGPT.
   * Khởi động Phoenix server bằng lệnh `mix phx.server` hoặc chạy trong IEx với `iex -S mix phx.server`.
   * Bây giờ, bạn có thể truy cập `localhost:4000` trên trình duyệt.
   * Vào Cloudinary tạo tài khoản để lấy API rồi vào dev.exs.
   * Thay đổi cấu hình repo của bạn. Chạy `mix ecto.create` và tôi không biết chỉ cần đảm bảo cơ sở dữ liệu của bạn có thể chạy.
Lưu ý:
   - Mở OBS, vào Cài đặt → Stream →
   - Service: Chọn Custom
   - Server: Nhập `rtmp://localhost:9006`
   - Stream Key: Nhập `hehe`
   - Nếu muốn đổi Stream Key, hãy vào file `lib/demo/application.ex`.
   - Khi bắt đầu stream mới, toàn bộ dữ liệu stream cũ sẽ bị xóa. Nếu muốn thay đổi, hãy sửa trong `lib/demo/application.ex`.
   - Để tìm hiểu thêm về Membrane, hãy truy cập trang web của họ.
   - Khi bạn stream vào trang stream tùy chỉnh, nhấp vào ok để stream
   - Nhấp vào nút "Chuyển đổi và tải video" để tải video xuống sau đó đợi nút "Tải luồng video" để tải video xuống là được

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
# demo_stream_with_membrane_elixir
