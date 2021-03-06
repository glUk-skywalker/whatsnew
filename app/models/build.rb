class Build < ActiveRecord::Base
  PROCESSED_BUG_STATUSES = %w[VERIFIED CLOSED INVALID TO-VERIFY TO-DOCUMENT DOCUMENTED].freeze
  PROCESSED_TASK_STATUSES = %w[RESOLVED DUPLICATE WONTFIX].freeze

  def bugs_info
    return @bugs_info if @bugs_info                                             # avoid extra requests if information exists
    bugs = BugzillaClient.get_bugs bug_list
    bugs_history = BugzillaClient.get_bugs_history bug_list
    info = (bugs + bugs_history).group_by{ |info| info["id"] }.map{ |k, v| v.reduce(:merge) } # merging bugs info and bugs history arrays in one
    @bugs_info = info.map{ |b| Bug.new(b).adjust_presence_in!(self).to_h }      # setting up the flag of presence in the current build
    @bugs_info.delete_if{ |b| b[:status] == 'NEW' }                             # filtering out the bugs that aren't fixed
  end

  def tasks_info
    return @tasks_info if @tasks_info
    @tasks_info = PhabricatorClient.get_tasks(task_ids).map(&:to_h)
  end

  def issues_info
    bugs_info
  end

  def bugs?
    bug_list.split(',').any?
  end

  def tasks?
    task_list.split(',').any?
  end

  def bugs_processed?
    bugs_info.reject{ |b|
      PROCESSED_BUG_STATUSES.include?(b[:status])
    }.empty?
  end

  def tasks_processed?
    tasks_info.reject{ |t|
      PROCESSED_TASK_STATUSES.include?(t[:status])
    }.empty?
  end

  def set_processed!
    self.processed = bugs_processed? && tasks_processed?
    save
  end

  private

  def task_ids
    task_list.to_s.split(',').map{ |t| t[1..-1]}
  end
end
