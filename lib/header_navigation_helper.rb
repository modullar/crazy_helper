module HeaderNavigationHelper
  
  # lots of code cut here ...

  def nav_primary(client: false)
    if current_user
      nav = [
              {text: 'My Projects',     url: my_projects_path},
              {url: inbox_path,         block: ("Messages" + (current_user.unread_messages.present? ? " <span class=\"unread-messages\">#{current_user.unread_messages.count}<span>" : '')).html_safe}
            ]
      if current_user.client?
        nav.unshift({text: 'My Company',    url: company_dashboard_path})
      else
        nav.unshift({text: 'Find Projects', url: contests_path})
      end
    else
      nav = [
              {text: 'How it works',    url: profiles_path},
              {text: 'Blog',            url: "#{APP_URL}/blog"}
            ]
      if client
        nav.insert(1, {text: 'About Us',             url: "#{APP_URL}/about"})
      else
        nav.insert(0, {text: 'Browse Projects',   url: contests_path})
      end
    end
  end

  def nav_secondary
    if current_user
      nav = [
              {text: 'My Profile',      url: profile_path(current_profile)},
              {text: 'Settings',        url: edit_profile_path(current_profile)},
              {text: "Find #{current_user.try(:client?) ? 'Creatives' : 'Collaborators'}",    url: profiles_path},
            ]
      nav.unshift({text: 'Latest Ideas', url: contest_ideas_path(current_user.jury_in_contest)}) if current_user.jury_in_contest
      if original_user
        nav.push({text: '☯ Excarnate',  url: unpretend_path, options: {style: 'color: green'}})
      else
        nav.push({text: 'Log out',      url: logout_path})
      end
    else
      []
    end
  end
  
  # lots of code cut here ...
  
end