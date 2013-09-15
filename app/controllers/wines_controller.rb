class WinesController < InheritedResources::Base
  actions :index, :show
  layout 'sidebar', only: :show

  def show
    show! do
      add_crumb(I18n.t("controller.wines"), wines_path)
      add_crumb(@wine, wine_path(@wine))
    end
  end

  protected
  def collection
    add_crumb(I18n.t("controller.wines"), wines_path)

    @wines ||= end_of_association_chain.page(params[:page])
  end

end
