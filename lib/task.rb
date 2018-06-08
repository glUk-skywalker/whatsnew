class Task
  def initialize(info)
    @info = info
    @info.total_symbolize_keys!
    @info[:kind] = 'task'
  end

  def to_h
    @info
  end
end
