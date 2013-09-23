class WinesController < InheritedResources::Base
  actions :index, :show
  layout 'sidebar', only: :show

  def show
    show! do
      @wine_monitor_groups = @wine.wine_monitors.group_by{ |wm| wm.lib}
      @cheapest = @wine.wine_prices.running.cheapest.first
      add_crumb(I18n.t("controller.wines"), wines_path)
      add_crumb(@wine, wine_path(@wine))
    end
  end

  def links
    @wine_price = WinePrice.find params[:id]
    redirect_to @wine_price.url
  end

  protected
  def collection
    add_crumb(I18n.t("controller.wines"), wines_path)
    @wines ||= end_of_association_chain.page(params[:page])
  end

end
