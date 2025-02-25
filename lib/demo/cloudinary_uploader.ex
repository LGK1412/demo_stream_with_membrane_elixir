defmodule Demo.CloudinaryUploader do
    @moduledoc false
    @cloudinary_url "https://api.cloudinary.com/v1_1"

    def get_upload_preset() do
      "upload_vid" # Tạo trong Cloudinary > Settings > Upload
    end

    def get_cloud_name() do
      Application.get_env(:demo, __MODULE__)[:cloud_name]
    end

    def get_upload_url() do
      "#{@cloudinary_url}/#{get_cloud_name()}/video/upload"
    end
end
