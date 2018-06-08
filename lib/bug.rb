class Bug
  def initialize(info)
    @info = info

    @info.total_symbolize_keys!
    adjust_tester_relations!
  end

  def adjust_presence_in!(build)
    if last_commit_time
      @info[:included] = build.whatsnew_time > last_commit_time
    else
      @info[:included] = true
    end

    self
  end

  def to_h
    @info
  end

  private

  def adjust_tester_relations!
    relations = []
    Settings.testers.each do |tester|
      relation = []
      relation << 'creator' if @info[:creator] == tester
      relation << 'CC' if @info[:cc].include? tester
      relation << 'qa contact' if @info[:qa_contact] == tester

      next if relation.empty?
      relations << { tester: tester, relation: relation.join(', ') }
    end
    @info[:relations] = relations
  end

  def last_commit_time
    # filtering out inessential items
    commits_history = @info[:history].select{ |event|
      event[:changes].any?{ |c|
        c.value?('cf_reporev') || c.value?('whiteboard')
      }
    }
    return nil unless commits_history.any?
    commits_history.min{ |a, b| b[:when].to_time <=> a[:when].to_time }[:when].to_time
  end
end
