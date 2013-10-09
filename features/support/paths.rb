module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the login page/
      '/users/sign_in'

    when /the home\s?page/
      '/'

    when /the register page/
      '/users/sign_up'

    when /the dive page for (.*)/
      dive_path($1)

    when /the latest dive page/
      edit_dive_path(Dive.last)

    when /the dive page for the first dive/
      edit_dive_path(Dive.first)

    when /the edit dive page for (.*)/
      edit_dive_path($1)
    when /the dive feed page/
      '/latest'

    when /the profile page for (.*)$/
      profile_path(User.find_by_cached_slug($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
