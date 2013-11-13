class User::WineLinksController < InheritedResources::Base
  actions :new, :create
  def create
    create! do |success, failure|
      success.html{
        if @wine_link.wine_monitor
          redirect_to @wine_link.wine_monitor
        else
          render :create
        end
      }
    end
  end

  protected
  def begin_of_association_chain
    current_user
  end
end
