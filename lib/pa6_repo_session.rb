class PA6RepoSession
  def new
    @repo = Git.open Settings.pa6_repo_path
  end

  def last_tag
    @last_tag ||= last_tags.last.name
  end

  def tag_date(tag)
    
  end
end
