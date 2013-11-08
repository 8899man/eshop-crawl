class UserMonitorsController < InheritedResources::Base
  before_filter :authenticate_user!
  layout 'sidebar', only: :show
  respond_to :js

  def new
    @user_monitor = current_user.user_monitors.new(wine_monitor: WineMonitor.find(params[:wine_monitor_id]))
  end

  def show
    show! do
      add_crumb(I18n.t("controller.user_monitors"), user_monitors_path)
      add_crumb(@user_monitor, user_monitor_path(@user_monitor))
    end
  end

  #def create
    #@user_monitor = current_user.user_monitors.create(warn_price: params[:user_monitor][:warn_price], wine_monitor: WineMonitor.find(params[:user_monitor][:wine_monitor_id]))
    #debugger
    #p @user_monitor
  #end

  protected
  def begin_of_association_chain
    current_user
  end

  def collection
    add_crumb(I18n.t("controller.user_monitors"), user_monitors_path)
    @user_monitors ||= end_of_association_chain.recent.page(params[:page])
  end

end

