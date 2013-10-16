class CommentsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :js
  belongs_to :commodity, optional: true
  belongs_to :group, optional: true
  belongs_to :article, optional: true
  actions :index, :create

  def index
    index! do
      if parent
        add_crumb(I18n.t("controller.#{parent.class.name.downcase.pluralize}"), polymorphic_path(parent.class))
        add_crumb(parent.name, polymorphic_path(parent))
      end
      add_crumb(I18n.t("controller.comments"))
    end
  end

  def create
    create! do |s,f|
      s.html{
        redirect_to parent? ? parent : system_contact_path
      }
      s.js{
        @comment.user = current_user
        @comment.save
        flash[:notice] = '提交成功'
      }
      f.js{
        flash[:error] = @comment.errors.full_messages
        render 'application/failure'
      }
    end
  end

  protected
  def collection
    @comments ||= end_of_association_chain.recent.page params[:cpage]
  end
end
