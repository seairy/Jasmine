# -*- encoding : utf-8 -*-
module Wechat::BaseHelper
  def header_tag
    raw "<header class=\"header\">
      #{image_tag 'wechat/blank.png', data: { original: 'header.jpg' }}
    </header>"
  end

  def footer_tag
    raw "<footer class=\"footer\">
      <ul class=\"clearfix\">
        <li class=\"tab-1\"><i class=\"fa fa-suitcase\"></i>#{link_to '想要', new_wechat_task_path }</li>
        <li class=\"tab-2\"><i class=\"fa fa-plane\"></i>#{link_to '信鸽', published_wechat_tasks_path }</li>
        <li class=\"tab-3\"><i class=\"fa fa-compass\"></i>#{link_to '发现', new_wechat_task_path }</li>
        <li class=\"tab-4\"><i class=\"fa fa-user\"></i>#{link_to '个人', wechat_dashboard_path }</li>
      </ul>
    </footer>"
  end

  def read_before_path
    if session['before_path']
      uri = URI(session['before_path'])
      uri.query ? (uri.query = 'read_instruction=yes') : (uri.query = 'read_instruction=yes')
      uri.to_s
    else
      published_wechat_tasks_path
    end
  end
end