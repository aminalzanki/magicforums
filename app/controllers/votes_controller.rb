class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!
  before_action :find_or_create_vote

  def upvote
    voting(1)
    flash.now[:success] = "Vote +1"
  end

  def downvote
    voting(-1)
    flash.now[:success] = "Vote: -1"
  end

  def find_or_create_vote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
  end

  def voting(value)
    @vote.update(value: value)
  end
end
