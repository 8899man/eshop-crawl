class WineMonitorsController < InheritedResources::Base
  before_filter :authenticate_user!,only: [:new,:create]
  actions :index, :show, :new, :create
  layout 'sidebar', only: :show

  def show
    show! do
      add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
      add_crumb(@wine_monitor, wine_path(@wine_monitor))
    end
  end

  def links
    @wine_monitor = WineMonitor.find(params[:id])
    redirect_to @wine_monitor.url
  end

  protected
  def begin_of_association_chain
    current_user
  end

  def collection
    add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
    @wine_monitors ||= end_of_association_chain.recent.page(params[:page])
  end

end
