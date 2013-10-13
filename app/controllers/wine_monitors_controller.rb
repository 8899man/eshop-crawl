class WineMonitorsController < InheritedResources::Base
  actions :index, :show
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
  def collection
    add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
    @wine_monitors ||= end_of_association_chain.recent.page(params[:page])
  end

end
