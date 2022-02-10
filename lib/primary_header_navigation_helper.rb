# frozen_string_literal: true

module PrimaryHeaderNavigationHelper
  
  def nav_primary(client: false)
    return current_user_navigation if current_user

    guest_default_navigation(client: client)
  end
  
  private

  def current_user_navigation
    return user_default_navigation.unshift(company_tab) if current_user.client?
  
    user_default_navigation.unshift(project_tab)
  end

  def guest_default_navigation(client: false)
    if client
      guest_default_navigation.insert(1, about_us_tab)
    else
      guest_default_navigation.insert(0, projects_tab)
    end
  end

  def user_default_navigation
    [ my_projects_tab, inbox_tab ]
  end

  def guest_default_navigation
    [ how_it_works_tab, blog_tab ]
  end

  def how_it_works_tab
    {text: 'How it works', url: profiles_path}
  end

  def blog_tab
    {text: 'Blog', url: "#{APP_URL}/blog"}
  end

  def company_tab
    { text: 'My Company',    url: company_dashboard_path }
  end
  
  def project_tab
    {text: 'Find Projects', url: contests_path}
  end

  def inbox_tab
    {url: inbox_path,         block: messages_block}
  end

  def messages_block
    ("Messages" + (messages_count > 0 ? unread_span(messages_count) : ''))
  end

  def unread_span(messages_count)
    "<span class=\"unread-messages\">#{current_user.unread_messages.count}<span>"
  end

  def messages_count
    current_user.unread_messages.count
  end

  def about_us_tab
    {text: 'About Us', url: "#{APP_URL}/about"}
  end

  def projects_tab
    {text: 'Browse Projects', url: contests_path}
  end

  def my_projects_tab
    {text: 'My Projects', url: my_projects_path}
  end
end