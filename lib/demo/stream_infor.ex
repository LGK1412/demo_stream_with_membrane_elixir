defmodule Demo.StreamInfor do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :streamer_id, :output_path, :stream_status, :inserted_at, :updated_at]}
  schema "stream_infor" do
    field :streamer_id, :integer
    field :output_path, :string
    field :stream_status, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stream_infor, attrs) do
    stream_infor
    |> cast(attrs, [:streamer_id, :output_path, :stream_status])
    |> validate_required([:streamer_id, :stream_status])
  end
end
