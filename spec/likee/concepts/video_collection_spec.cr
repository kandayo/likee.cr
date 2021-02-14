require "../../spec_helper"

describe Likee::VideoCollection do
  describe ".from_json" do
    it "parses the PostList from the response_body" do
      collection = Likee::VideoCollection.from_json(mocked_post_list, root: "data")

      video1 = collection.videos[0]
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
      video1.share_url.should eq("")
      video1.music_id.should eq("")
      video1.music_name.should eq("Likee US")

      video2 = collection.videos[1]
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
      video2.share_url.should eq("")
      video2.music_id.should eq("")
      video2.music_name.should eq("Likee US")
    end
  end

  describe "#last_post_id" do
    context "when video collection is not empty" do
      it "returns the last post id" do
        collection = Likee::VideoCollection.from_json(mocked_post_list, root: "data")
        collection.last_post_id.should eq("6928474090370004279")
      end
    end
  end
end