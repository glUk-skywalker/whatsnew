require 'git'

class PA6Repo
  ISSUE_PATTERN = {
    bug:  /:R5:\d+/,
    task: /:R5:T\d+/
  }

  def initialize
    @repo = Git.open Settings.pa6_repo_path
    @repo.fetch
  end

  def self.last_build_info
    r = new
    {
      number: r.last_tags.last.name[1..-1],
      tag: 'alpha',
      whatsnew_time: r.last_build_date,
      bug_list: r.issue_list(:bug),
      task_list: r.issue_list(:task)
    }
  end

  def issue_list(type)
    ret = []
    r5messages.each do |m|
      matches = m.scan(ISSUE_PATTERN[type])
      ret << matches.first[4..-1] if matches.any?
    end
    ret.join(',')
  end

  def r5messages
    return @r5messages if @r5messages
    msgs = []
    commits.each do |c|
      msg = c.message.split("\n").first
      msgs << msg if msg.include?(':R5')
    end
    @r5messages = msgs
  end

  def commits
    @commits ||= @repo.log(1000).between(*last_tags.map(&:name))
  end

  def last_tags
    @last_tags ||= @repo.tags[-2..-1]
  end

  def last_build_date
    commits.first.date
  end
end
