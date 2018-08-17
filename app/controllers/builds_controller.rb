class BuildsController < AuthenticatedUserController
  def index
    @builds = Build.order('whatsnew_time DESC')
  end

  def show
    @build = Build.find(params[:id])
    @build.set_processed!

    respond_to do |format|
      format.js { authenticated? }
      format.html { redirect_to root_path }
    end
  end
end
