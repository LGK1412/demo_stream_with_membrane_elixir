defmodule Demo.StreamsTest do
  use Demo.DataCase

  alias Demo.Streams

  describe "stream_infor" do
    alias Demo.Streams.StreamInfor

    import Demo.StreamsFixtures

    @invalid_attrs %{streamer_id: nil, streamer_name: nil, output_path: nil, stream_status: nil}

    test "list_stream_infor/0 returns all stream_infor" do
      stream_infor = stream_infor_fixture()
      assert Streams.list_stream_infor() == [stream_infor]
    end

    test "get_stream_infor!/1 returns the stream_infor with given id" do
      stream_infor = stream_infor_fixture()
      assert Streams.get_stream_infor!(stream_infor.id) == stream_infor
    end

    test "create_stream_infor/1 with valid data creates a stream_infor" do
      valid_attrs = %{streamer_id: 42, streamer_name: "some streamer_name", output_path: "some output_path", stream_status: true}

      assert {:ok, %StreamInfor{} = stream_infor} = Streams.create_stream_infor(valid_attrs)
      assert stream_infor.streamer_id == 42
      assert stream_infor.streamer_name == "some streamer_name"
      assert stream_infor.output_path == "some output_path"
      assert stream_infor.stream_status == true
    end

    test "create_stream_infor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Streams.create_stream_infor(@invalid_attrs)
    end

    test "update_stream_infor/2 with valid data updates the stream_infor" do
      stream_infor = stream_infor_fixture()
      update_attrs = %{streamer_id: 43, streamer_name: "some updated streamer_name", output_path: "some updated output_path", stream_status: false}

      assert {:ok, %StreamInfor{} = stream_infor} = Streams.update_stream_infor(stream_infor, update_attrs)
      assert stream_infor.streamer_id == 43
      assert stream_infor.streamer_name == "some updated streamer_name"
      assert stream_infor.output_path == "some updated output_path"
      assert stream_infor.stream_status == false
    end

    test "update_stream_infor/2 with invalid data returns error changeset" do
      stream_infor = stream_infor_fixture()
      assert {:error, %Ecto.Changeset{}} = Streams.update_stream_infor(stream_infor, @invalid_attrs)
      assert stream_infor == Streams.get_stream_infor!(stream_infor.id)
    end

    test "delete_stream_infor/1 deletes the stream_infor" do
      stream_infor = stream_infor_fixture()
      assert {:ok, %StreamInfor{}} = Streams.delete_stream_infor(stream_infor)
      assert_raise Ecto.NoResultsError, fn -> Streams.get_stream_infor!(stream_infor.id) end
    end

    test "change_stream_infor/1 returns a stream_infor changeset" do
      stream_infor = stream_infor_fixture()
      assert %Ecto.Changeset{} = Streams.change_stream_infor(stream_infor)
    end
  end
end
