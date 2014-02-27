class WineMonitorsController < InheritedResources::Base
  before_filter :authenticate_user!,only: [:new,:create]
  actions :index, :show, :new, :create
  layout 'sidebar', only: :show

  def index
    index! do
      ['main_type', 'type', 'country', 'brand'].each do |sym|
        @wine_monitors = @wine_monitors.tagged_with_on(sym.tableize.to_sym, params[sym]) unless params[sym].blank?
      end
    end
  end

  def show
    show! do
      add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
      add_crumb(@wine_monitor, wine_path(@wine_monitor))
    end
  end

  def links
    if YAML.load(ENV['CRAWLS']).include?(params[:lib])
      redirect_to params[:lib].constantize.new({id: params[:id]}).go_url
    end
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

  def search
    if params[:q].blank?
      redirect_to wine_monitors_path
    else
    s = WineMonitor.full_search(params[:q], params[:page], params)
    @keys = params[:q].blank? ? [] : params[:q].split(' ').uniq
    @wine_monitors = s.results
    add_crumb(I18n.t("controller.wine_monitors"), wine_monitors_path)
    add_crumb('搜索')#, categories_wine_monitors_path)
    end
    #respond_to do |f|
      #f.json{render json: {results: @wine_monitor, has_next: !@wine_monitor.last_page?}}
      #f.html
    #end
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
