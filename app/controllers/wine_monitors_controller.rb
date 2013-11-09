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

  def categories
    @categories = WineMonitor.categories
  end

  def category
    @category = params[:id]
    unless params[:sort].blank?
      @wine_monitors ||= WineMonitor.category(params[:id]).sorted(params[:sort] || '').page(params[:page])
    else
      @wine_monitors ||= WineMonitor.category(params[:id]).recent.page(params[:page])
    end
    add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
    add_crumb('分类', categories_wine_monitors_path)
    add_crumb(@category, category_wine_monitors_path(@category))
    render :index
  end

  protected
  def collection
    add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
    unless params[:sort].blank?
      @wine_monitors ||= end_of_association_chain.sorted(params[:sort] || '').page(params[:page])
    else
      @wine_monitors ||= end_of_association_chain.recent.page(params[:page])
    end
  end

end
