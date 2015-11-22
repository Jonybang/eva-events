class InheritsController < ApplicationController
  skip_before_action :verify_authenticity_token

  inherit_resources

  respond_to :json
  before_action :get_collection, only: :index
  before_action :get_resource, only: :show

  before_action :is_auth, only: [:create, :destroy, :update]

  def create
    create! { redirect_to resource_url and return }
  end

  def update
    update! { get_resource and render :show and return }
  end

  def render *args
    sort_and_paging
    filtering
    super
  end
  protected
    def get_resource
      @resource = resource
    end
    def get_collection
      @collection = collection
      #if params[:q]
       # @collection = @collection.ransack(params[:q])
      #end
    end
    def sort_and_paging
      unless @collection
        return
      end
      if params[:sort]
        @collection = @collection.sorted(sort: params[:sort])
      end
      if params[:limit]
        @collection = @collection.limit(params[:limit])
      end
    end
  def filtering
    unless @collection
      return
    end
    if params[:less_created_at]
      @collection = @collection.where('created_at < (?)', params[:less_created_at])
    end
  end
    def is_auth
      unless session[:user_id]
        return head(401)
      end
    end
end
