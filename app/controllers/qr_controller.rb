class QrController < ActionController::Base
  def index
    if params[:id] && params[:class]
      @resource = (params[:class].slice(0,1).capitalize + params[:class].slice(1..-1)).classify.constantize.find params[:id]
      @url = request.base_url + @resource.alias_url
      qr = RQRCode::QRCode.new( @url, :size => 5, :level => :h )
      #@qr_code = qr.to_img.resize(300, 300)
      @qr_code = qr.to_img.resize(700, 700)
    end
  end
end