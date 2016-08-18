class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!
  before_action :find_or_create

  def upvote
    updateVote(1)
    flash.now[:success] = "You have upvote this comment."
  end

  def downvote
    updateVote(-1)
    flash.now[:danger] = "You have downvote this comment."
  end

  private

  def find_or_create
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
    @comment = Comment.find_by(id: params[:comment_id])
  end

  def updateVote(value)
    @vote.update(value: value)
    VoteBroadcastJob.perform_later(@vote.comment)
  end
end
