defmodule Demo.Streams do
  @moduledoc """
  The Streams context.
  """

  import Ecto.Query, warn: false
  alias Demo.Repo

  alias Demo.Streams.StreamInfor

  @doc """
  Returns the list of stream_infor.
  """
  def list_stream_infor do
    Repo.all(StreamInfor)
  end

  @doc """
  Gets a single stream_infor.

  Raises `Ecto.NoResultsError` if the Stream infor does not exist.
  """
  def get_stream_infor!(id), do: Repo.get!(StreamInfor, id)

  @doc """
  Creates a stream_infor.
  """
  def create_stream_infor(attrs \\ %{}) do
    %StreamInfor{}
    |> StreamInfor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stream_infor.
  """
  def update_stream_infor(%StreamInfor{} = stream_infor, attrs) do
    stream_infor
    |> StreamInfor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stream_infor.
  """
  def delete_stream_infor(%StreamInfor{} = stream_infor) do
    Repo.delete(stream_infor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stream_infor changes.
  """
  def change_stream_infor(%StreamInfor{} = stream_infor, attrs \\ %{}) do
    StreamInfor.changeset(stream_infor, attrs)
  end


  # Lấy stream_id theo streamer_name và stream_status = true
  def get_stream_by_streamer_id(streamer_id) do
    Repo.one(
      from s in StreamInfor,
      where: s.streamer_id == ^streamer_id and s.stream_status == true
    )
  end

  def update_output_path(%StreamInfor{} = stream, new_path) do
    stream
    |> StreamInfor.changeset(%{output_path: new_path})
    |> Repo.update()
  end

  def update_stream_status_when_stop_stream(streamer_id) do
    case Repo.get_by(StreamInfor, [streamer_id: streamer_id, stream_status: true]) do
      nil -> {:error, "Stream not found or already stopped"}
      stream ->
        stream
        |> StreamInfor.changeset(%{stream_status: false})
        |> Repo.update()
    end
  end

  # Cái này cho user nếu có sẵn khỏi dem qua
  def get_streamer_id_by_name(streamer_name) do
    Repo.one(
      from u in Demo.Accounts.User,  # Thêm đầy đủ namespace
      where: u.display_name == ^streamer_name,
      select: u.id
    )
  end

  def is_streamer(streamer_id) do
  query = from s in Demo.Streams.StreamInfor,
          where: s.streamer_id == ^streamer_id,
          select: count(s.id) > 0

  Repo.one(query)
end
end
