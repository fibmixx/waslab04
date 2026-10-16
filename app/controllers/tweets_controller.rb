class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ show edit update destroy ]

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id]) if session[:current_user_id]
  end
  
  # GET /tweets
  def index
    @tweets = Tweet.all.order(created_at: :desc)
  end

  # GET /tweets/1
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  def create
    @tweet = Tweet.new(tweet_params)
  
    if @tweet.save
      redirect_to @tweet, notice: "Tweet was successfully created."
      session[:authored_ids] ||= []
      session[:authored_ids] << @tweet.id
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "Tweet was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /tweets/1
  def destroy
    if session[:authored_ids].blank? || !session[:authored_ids].include?(@tweet.id)
      redirect_to @tweet, alert: "You are not allowed to delete this tweet", status: :see_other
    else
      @tweet.destroy!
      redirect_to tweets_path, notice: "Tweet was successfully destroyed.", status: :see_other
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.expect(tweet: [ :author, :content ])
    end
end
