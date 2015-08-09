class InheritsController < ApplicationController
  inherit_resources

  respond_to :json
  before_action :get_collection, only: :index
  before_action :get_resource, only: :show

  def create
    create! { redirect_to resource_url and return }
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
      @collection = sort_and_paging @collection
    end
    def sort_and_paging(collection)
      if params[:sort]
        collection = collection.sorted(order: params[:sort])
      end
      if params[:limit]
        collection = collection.limit(params[:limit])
      end
      collection
    end
end
