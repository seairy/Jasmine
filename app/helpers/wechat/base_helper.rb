# -*- encoding : utf-8 -*-
module Wechat::BaseHelper
  def flash_tag
    content_tag(:p, flash[:alert], class: 'alert') if flash[:alert]
  end

  def menu_tag
    raw "<ul class=\"menu-top\">
      <li><a href=\"#{url_for(new_wechat_task_path)}\"><i class=\"fa fa-suitcase\"></i>发布需求<i class=\"fa fa-circle\"></i></a></li>
      <li>
        <a class=\"has-submenu\" href=\"#\"><i class=\"fa fa-cog\"></i>我想要<i class=\"fa fa-plus\"></i></a>
        <ul class=\"submenu\">
          <li><a href=\"features-type.html\"><i class=\"fa fa-angle-right\"></i>需求列表<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"features-jquery.html\"><i class=\"fa fa-angle-right\"></i>jQuery Features<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"features-others.html\"><i class=\"fa fa-angle-right\"></i>Other Features<i class=\"fa fa-circle\"></i></a></li>
        </ul>
      </li>
      <li>
        <a class=\"has-submenu\" href=\"#\"><i class=\"fa fa-mobile\"></i>App Specific<i class=\"fa fa-plus active-plus\"></i></a>
        <ul class=\"submenu show-submenu\">
          <li class=\"active-menu\"><a href=\"pageapp-login.html\"><i class=\"fa fa-angle-right\"></i>Login<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-singup.html\"><i class=\"fa fa-angle-right\"></i>Signup<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-coverpage.html\"><i class=\"fa fa-angle-right\"></i>Coverpage<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-userlist.html\"><i class=\"fa fa-angle-right\"></i>Userlist<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-calendar.html\"><i class=\"fa fa-angle-right\"></i>Calendar<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-activity.html\"><i class=\"fa fa-angle-right\"></i>Activity Feed<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-chat.html\"><i class=\"fa fa-angle-right\"></i>Chat Bubbles<i class=\"fa fa-circle\"></i></a></li>
          <li><a href=\"pageapp-share.html\"><i class=\"fa fa-angle-right\"></i>Share Boxes<i class=\"fa fa-circle\"></i></a></li>
        </ul>
      </li>
      <li><a href=\"contact.html\"><i class=\"fa fa-envelope-o\"></i>Contact<i class=\"fa fa-circle\"></i></a></li>
      <li><a class=\"close-menu\" href=\"#\"><i class=\"fa fa-times\"></i>Close<i class=\"fa fa-circle\"></i></a></li>
    </ul>"
  end
end