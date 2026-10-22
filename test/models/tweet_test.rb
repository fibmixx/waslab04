require "test_helper"

class TweetTest < ActiveSupport::TestCase
  test "valid tweet" do
    tweet = Tweet.new(author: "Alice", content: "Hello wall of tweets")
    assert tweet.valid?
  end

  test "author must be between 4 and 20 characters" do
    tweet = Tweet.new(author: "abc", content: "Valid content")
    assert_not tweet.valid?
    assert_includes tweet.errors[:author], "is too short (minimum is 4 characters)"

    tweet.author = "a" * 21
    assert_not tweet.valid?
    assert_includes tweet.errors[:author], "is too long (maximum is 20 characters)"
  end

  test "content must be between 4 and 280 characters" do
    tweet = Tweet.new(author: "Alice", content: "abc")
    assert_not tweet.valid?
    assert_includes tweet.errors[:content], "is too short (minimum is 4 characters)"

    tweet.content = "a" * 281
    assert_not tweet.valid?
    assert_includes tweet.errors[:content], "is too long (maximum is 280 characters)"
  end
end
