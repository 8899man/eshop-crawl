class WinesController < InheritedResources::Base
  actions :index, :show
  protected
  def collection
    #if parent?
      #add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
      #add_crumb(parent.name, polymorphic_path(parent))
    #end
    #add_crumb(I18n.t("controller.wines"), wines_path)

    @wines ||= end_of_association_chain.page(params[:page])
  end

end
