class ApplicationController < ActionController::Base
  before_action(:reset_stale_session)
  before_action(:load_current_user)

  def reset_stale_session
    current_user_id = session.fetch(:user_id)

    if current_user_id != nil
      current_user = User.where({ :id => current_user_id }).at(0)
      
      if current_user == nil
        reset_session
        redirect_to("/", { :alert => "Whaaaaattt? How did I end up here? Your current user ID was stale (likely due to a sample data reset), so instead of causing an error we deleted your cookies and brought you back to the homepage. Please sign in again." })
      end
    end
  end
  
  def load_current_user
    the_id = session.fetch(:user_id)
    matching_user_records = User.where({ :id => the_id })
    @current_user = matching_user_records.at(0)
  end
end
