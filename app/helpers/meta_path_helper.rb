module MetaPathHelper

  def meta_path
    action = "#{controller.controller_name}##{controller.action_name}"
    case action
    when "topics#index"
      link_to "New Topic", new_topic_path
    when "posts#index"
      link_to "New Post", new_topic_post_path(@topic)
    else
      link_to "Topics", topics_path
    end
  end
end
