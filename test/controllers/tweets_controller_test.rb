require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tweet = tweets(:one)
  end

  test "should get index" do
    get tweets_url
    assert_response :success
    assert_select ".wottitle", text: "Wall of Tweets · RoR Edition"
    assert_select ".walltweet"
  end

  test "should get new" do
    get new_tweet_url
    assert_response :success
    assert_select ".wottitle"
    assert_select ".walltweet"
  end

  test "should create tweet" do
    assert_difference("Tweet.count") do
      post tweets_url, params: { tweet: { author: "ValidAuthor", content: "Valid tweet content" } }
    end

    assert_redirected_to root_url
  end

  test "should show validation errors and keep submitted values" do
    post tweets_url, params: { tweet: { author: "ab", content: "xy" } }

    assert_response :unprocessable_entity
    assert_select ".wottitle", text: "Wall of Tweets · RoR Edition"
    assert_select ".flash--alert", /Author is too short/
    assert_select ".flash--alert", /Content is too short/
    assert_select "#tweet_author[value=?]", "ab"
    assert_select "textarea#tweet_content", text: "xy"
  end

  test "should show tweet" do
    get tweet_url(@tweet)
    assert_response :success
    assert_select ".wottitle"
    assert_select ".wotitem"
  end

  test "should like a tweet once per session" do
    assert_difference("@tweet.reload.likes") do
      put like_tweet_url(@tweet)
    end

    assert_redirected_to root_url

    assert_no_difference("@tweet.reload.likes") do
      put like_tweet_url(@tweet)
    end

    get tweets_url
    assert_select "#tweet_#{@tweet.id} button.btn-disabled[disabled]", text: "liked"
  end

  test "should get edit" do
    get edit_tweet_url(@tweet)
    assert_response :success
    assert_select ".wottitle"
    assert_select ".walltweet"
  end

  test "should update tweet" do
    patch tweet_url(@tweet), params: { tweet: { author: @tweet.author, content: @tweet.content } }
    assert_redirected_to tweet_url(@tweet)
  end

  test "should destroy tweet authored in current session" do
    post tweets_url, params: { tweet: { author: "SessionAuthor", content: "Tweet created in this session" } }
    authored = Tweet.last

    assert_difference("Tweet.count", -1) do
      delete tweet_url(authored)
    end

    assert_redirected_to root_url
  end

  test "should not destroy tweet from another session" do
    assert_no_difference("Tweet.count") do
      delete tweet_url(@tweet)
    end

    assert_redirected_to root_url
    follow_redirect!
    assert_select ".flash--alert", /not allowed/i
  end

  test "destroy button only appears for tweets authored in session" do
    post tweets_url, params: { tweet: { author: "SessionAuthor", content: "Tweet created in this session" } }
    authored = Tweet.last

    get tweets_url
    assert_select "#tweet_#{authored.id} button.btn-danger", text: "destroy"
    assert_select "#tweet_#{@tweet.id} button", text: "like"
    assert_select "#tweet_#{@tweet.id} button.btn-danger", count: 0
  end
end
