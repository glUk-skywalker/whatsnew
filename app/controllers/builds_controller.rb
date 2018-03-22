class BuildsController < AuthenticatedUserController
  include BuildsHelper

  def index
    @builds = Build.order('whatsnew_time DESC')
  end

  # def check
  #   check_build(params[:tag])
  #
  #   redirect_to root_path
  # end

  def show
    @build = Build.find(params[:id])

    last_commits = {}

    @build.bugs_info.each do |bug_history|
      date = time = nil
      (0..(bug_history[:history].length - 1)).reverse_each.each do |i|
        if reporev_changed?(bug_history[:history][i])
          date ||= bug_history[:history][i][:when].to_date
          time ||= bug_history[:history][i][:when].to_time
        end
      end

      if !date.nil?
        last_commits[ bug_history[:id] ] = DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec)
      end
    end


    @bugs = []
    @build.bugs_info.each do |bug|
      if last_commits[bug[:id]].nil?
        included = true
      else
        @build.whatsnew_time > last_commits[bug[:id]] ? included = true : included = false
      end

      @bugs << bug.merge({ included: included })
    end

    processed = true
    @bugs.each do |bug|
      processed = false if (bug[:status] == "RESOLVED" || bug[:status] == "TO-VERIFY" || bug[:status] == "TO-DOCUMENT") && bug[:included]
    end
    @build.update_attributes(processed: processed)

    respond_to do |format|
      format.js { authenticated? }
      format.html { redirect_to root_path }
    end
  end


protected

  def reporev_changed?(change)
    res = false
    change[:changes].each do |change|
      res = true if change.has_value?('cf_reporev') ||change.has_value?('whiteboard')
    end
    res
  end

end
