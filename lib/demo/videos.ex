defmodule Demo.Videos do
  import Ecto.Query, warn: false
  alias Demo.Repo
  alias Demo.Video

  # Lưu video vào database
  def create_video(attrs) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  # Lấy tất cả video
  def all_videos do
    Repo.all(Video)
  end

  def get_video(id) do
    Repo.get(Video, id)
  end
end
