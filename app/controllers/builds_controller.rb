class BuildsController < AuthenticatedUserController
  NOT_PROCESSED_BUG_STATUSES = %w[RESOLVED TO-VERIFY TO-DOCUMENT].freeze

  def index
    @builds = Build.order('whatsnew_time DESC')
  end

  def show
    @build = Build.find(params[:id])

    not_processed_bugs = @build.issues_info.select{ |b|
      b[:status].in?(NOT_PROCESSED_BUG_STATUSES) && b[:included]
    }
    @build.update_attributes(processed: not_processed_bugs.empty?)

    respond_to do |format|
      format.js { authenticated? }
      format.html { redirect_to root_path }
    end
  end
end
