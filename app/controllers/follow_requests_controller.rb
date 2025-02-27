class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    the_follow_request = FollowRequest.new
    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = session[:user_id]
    if User.where({:id => params.fetch("query_recipient_id")}).at(0).private
      the_follow_request.status = "pending"
    else
      the_follow_request.status = "accepted"
    end

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{User.where({:id =>params.fetch("query_recipient_id")}).at(0).username}", { :notice => "Follow request created successfully." })
    else
      redirect_to("/follow_requests", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/" + User.where({:id => the_follow_request.recipient_id}).at(0).username, { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/users/" + User.where({:id => the_follow_request.recipient_id}).at(0).username, { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def destroy
    recipient = params.fetch("path_id")
    sender = session[:user_id]
    the_follow_request = FollowRequest.where({ :recipient_id => recipient, :sender_id => sender }).at(0)

    the_follow_request.destroy

    user = User.where({:id => recipient}).at(0).username
    redirect_to("/users/" + user, { :notice => "Follow request deleted successfully."} )
  end
end
