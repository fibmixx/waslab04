class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ show edit update destroy like ]

  # GET /tweets
  def index
    @tweets = Tweet.all.order(created_at: :desc)
    @tweet ||= Tweet.new
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
      session[:authored_ids] ||= []
      session[:authored_ids] << @tweet.id
      redirect_to root_path, notice: "Tweet was successfully created."
    else
      @tweets = Tweet.all.order(created_at: :desc)
      flash.now[:alert] = @tweet.errors.full_messages.to_sentence
      render :index, status: :unprocessable_content
    end
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "Tweet was successfully updated.", status: :see_other
    else
      flash.now[:alert] = @tweet.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /tweets/1
  def destroy
    authored_ids = Array(session[:authored_ids]).map(&:to_i)

    if authored_ids.include?(@tweet.id)
      @tweet.destroy!
      redirect_to root_path, notice: "Tweet was successfully destroyed.", status: :see_other
    else
      redirect_to root_path, alert: "You are not allowed to delete this tweet", status: :see_other
    end
  end

  # PUT /tweets/1/like
  def like
    session[:liked_ids] ||= []
    liked_ids = session[:liked_ids].map(&:to_i)

    unless liked_ids.include?(@tweet.id)
      @tweet.increment!(:likes)
      session[:liked_ids] << @tweet.id
    end

    redirect_to root_path, status: :see_other
  end

  private
    def set_tweet
      @tweet = Tweet.find(params.expect(:id))
    end

    def tweet_params
      params.expect(tweet: [ :author, :content ])
    end
end
