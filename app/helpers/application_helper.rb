module ApplicationHelper
  def turbo_cache_control_meta_tag
    tag :meta, name: 'turbo-cache-control', content: @turbo_cache_control || 'cache'
  end
end
