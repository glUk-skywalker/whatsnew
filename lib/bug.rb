class Bug

  def initialize(info)
    @info = info
  end

  def adjust_tester_relations!
    relations = []
    Settings.testers.each do |tester|
      relation = []
      relation << 'creator' if @info['creator'] == tester
      relation << 'CC' if @info['cc'].include? tester
      relation << 'qa contact' if @info['qa_contact'] == tester

      unless relation.empty?
        relations << {
          tester: tester,
          relation: relation.join(', ')
        }
      end
    end
    @info['relations'] = relations
    return self
  end

  def to_h
    @info.total_symbolize_keys!
  end

end
