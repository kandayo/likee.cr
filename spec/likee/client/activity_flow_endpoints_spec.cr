require "./../../spec_helper"

describe Likee::Client::ActivityFlowEndpoints do
  describe ".user_videos" do
    it "gets a collection of videos published by the given user" do
      WebMock
        .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
        .with(body: {uid: "101", lastPostId: "100", count: 50, tabType: 0}.to_json)
        .to_return(status: 200, body: load_fixture("video_collection"))

      collection = Likee.user_videos(user_id: "101", last_post_id: "100", limit: 50)
      collection.size.should eq(2)

      video1 = collection[0]
      video1.id.should eq("6928482856398255415")
      video1.uploaded_at.should eq(Time.utc(2021, 2, 12, 20, 52, 3))
      video1.creator_id.should eq("30007")
      video1.creator_username.should eq("Likee_USA")
      video1.creator_nickname.should eq("Likee US")
      video1.creator_avatar.should eq("https://img.like.video/asia_live/3s1/2Fu61w.jpg")
      video1.title.should eq("")
      video1.caption.should eq("Loving this Valentine's look from @Sydney Purl")
      video1.play_count.should eq(43814_u32)
      video1.like_count.should eq(3961_u32)
      video1.comment_count.should eq(177_u32)
      video1.share_count.should eq(385_u32)
      video1.height.should eq(960_u16)
      video1.width.should eq(540_u16)
      video1.cover_url.should eq("https://videosnap.like.video/asia_live/3s1/014BdUm_4.jpg?wmk_sdk=1")
      video1.video_url.should eq("http://video.like.video/asia_live/3s1/2NACi5_4.mp4?crc=1896456546&type=5")
      video1.download_url.should eq("http://video.like.video/asia_live/3s1/2NACi5.mp4?crc=1896456546&type=5")
      video1.share_url.should eq("")
      video1.music_id.should eq("")
      video1.music_name.should eq("Likee US")

      video2 = collection[1]
      video2.id.should eq("6928474090370004279")
      video2.uploaded_at.should eq(Time.utc(2021, 2, 12, 20, 18, 2))
      video2.creator_id.should eq("30007")
      video2.creator_username.should eq("Likee_USA")
      video2.creator_nickname.should eq("Likee US")
      video2.creator_avatar.should eq("https://img.like.video/asia_live/3s1/2Fu61w.jpg")
      video2.title.should eq("")
      video2.caption.should eq("Seeing double 👯 @FireGoddess")
      video2.play_count.should eq(31441_u32)
      video2.like_count.should eq(1638_u32)
      video2.comment_count.should eq(209_u32)
      video2.share_count.should eq(187_u32)
      video2.height.should eq(960_u16)
      video2.width.should eq(540_u16)
      video2.cover_url.should eq("https://videosnap.like.video/asia_live/3s1/0LOVihq_4.jpg?wmk_sdk=1")
      video2.video_url.should eq("http://video.like.video/asia_live/3s3/1G6NQA_4.mp4?crc=701753824&type=5")
      video2.download_url.should eq("http://video.like.video/asia_live/3s3/1G6NQA.mp4?crc=701753824&type=5")
      video2.share_url.should eq("")
      video2.music_id.should eq("")
      video2.music_name.should eq("Likee US")
    end

    context "when last_post_id is not given" do
      it "sends lastPostId param as an empty string" do
        WebMock
          .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
          .with(body: {uid: "101", lastPostId: "", count: 50, tabType: 0}.to_json)
          .to_return(status: 200, body: load_fixture("video_collection"))

        collection = Likee.user_videos(user_id: "101", last_post_id: "", limit: 50)
        collection.size.should eq(2)
      end
    end

    context "when a HTTP error occurs" do
      it "raises Likee::RequestFailedError" do
        WebMock
          .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
          .with(body: {uid: "101", lastPostId: "100", count: 50, tabType: 0}.to_json)
          .to_return(status: 404)

        expect_raises(
          Likee::RequestFailedError,
          "HTTP status code 404: Not Found"
        ) do
          Likee.user_videos(user_id: "101", last_post_id: "100", limit: 50)
        end
      end
    end

    context "when Likee API returns a non-zero code" do
      it "raises Likee::RequestFailedError" do
        WebMock
          .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/videoApi/getUserVideo")
          .with(body: {uid: "101", lastPostId: "100", count: 50, tabType: 0}.to_json)
          .to_return(status: 200, body: load_fixture("api_error"))

        expect_raises(
          Likee::APIError,
          "Likee API code 41001: request method not support"
        ) do
          Likee.user_videos(user_id: "101", last_post_id: "100", limit: 50)
        end
      end
    end
  end

  describe "#user_posts_count" do
    it "gets the posts count of the given user" do
      WebMock
        .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/userApi/getUserPostNum")
        .with(body: {uid: "30000"}.to_json)
        .to_return(status: 200, body: load_fixture("user_posts_count"))

      posts_count = Likee.user_posts_count(user_id: "30000")
      posts_count.should_not be_nil

      if posts_count
        posts_count.likes_count.should eq(15_788_313)
        posts_count.videos_count.should eq(1_725)
        posts_count.moments_count.should eq(1)
      end
    end

    context "when a HTTP error occurs" do
      it "raises Likee::RequestFailedError" do
        WebMock
          .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/userApi/getUserPostNum")
          .with(body: {uid: "30000"}.to_json)
          .to_return(status: 404)

        expect_raises(
          Likee::RequestFailedError,
          "HTTP status code 404: Not Found"
        ) do
          Likee.user_posts_count(user_id: "30000")
        end
      end
    end

    context "when Likee API returns a non-zero code" do
      it "raises Likee::RequestFailedError" do
        WebMock
          .stub(:post, "https://api.like-video.com/likee-activity-flow-micro/userApi/getUserPostNum")
          .with(body: {uid: "30000"}.to_json)
          .to_return(status: 200, body: load_fixture("api_error"))

        expect_raises(
          Likee::APIError,
          "Likee API code 41001: request method not support"
        ) do
          Likee.user_posts_count(user_id: "30000")
        end
      end
    end
  end
end
