class PicsController < ApplicationController
  require 'fastimage'
  before_filter :store_calling_page, :only => [:show,  :index]
  after_filter :reset_current_setname, :except => :show 
  
	def save
		@pic=Pic.new(params[:pic])
    img_size = FastImage.size(@pic.img_src, :timeout => 5)
    if !img_size.nil?
      @pic.img_width = img_size[0]
      @pic.img_height = img_size[1]
    end
		@pic.save
    if @pic.valid?
      redirect_to "/show/#{@pic.setname}/last" 
    end
	end
  
	def new
    @title = "Add a new image..."
		@pic=Pic.new
    @pic.setname = session[:current_setname]
	end
	
	def show
    session[:current_setname] = params[:setname]

    # Get the pics in the requested set
    @title = params[:setname]
    this_set = @title
		pics=Pic.find_all_by_setname(this_set, :order => "created_at")
    @pics_count = pics.count
    
    # If there are no pics in the set, use all pics in database
		if @pics_count == 0
			pics=Pic.find(:all, :order => "created_at")
      @pics_count = pics.count
      @pic_num = 0
 	    @route_string="/show"
    else
      @pic_num = params[:id].to_i
      @route_string="/show/#{this_set}"
		end
    
    # Get the requested pic, resize if too large
		@pic=pics[@pic_num]
    # adjust height to fit
    height_limit = cookies[:height_max].nil? ? 600 : cookies[:height_max].to_i 
    width_limit = cookies[:width_max].nil? ? 600 : cookies[:width_max].to_i 
    height_ratio = @pic.img_height.to_f / height_limit.to_f
    width_ratio = @pic.img_width.to_f / width_limit.to_f
    ratio = height_ratio > width_ratio ? height_ratio : width_ratio
    ratio = ratio > 1 ? ratio : 1
    @pic_height = @pic.img_height.to_f / ratio
	end
	
	def delete
		delete_pic = Pic.find(params[:pic_id])
		delete_pic.destroy
		new_num = params[:pic_num].to_i
    new_num -= 1 if new_num > 0
    set_count = Pic.find_all_by_setname(params[:set_name]).count
    if set_count > 0
      redirect_to "/show/#{params[:set_name]}/#{new_num}"
    else
      redirect_to "/"
    end
	end
	
	def index
    @title = "Choose a picture set"
		@setnames= Pic.find( :all, :select => 'DISTINCT setname')
	end
		
	def last
		@pics = Pic.find_all_by_setname(params[:setname])
		redirect_to "/show/#{params[:setname]}/#{@pics.count-1}"
	end
  
  def slideshow
    @title = "Slideshow"
    pic_set = Pic.find_all_by_setname(params[:setname])
    @this_pic = pic_set[rand(pic_set.count)]
    @this_height = @height_limit
    @this_height = @this_pic.img_height if @this_pic.img_height < @height_limit
  end
  
  def getprefs
    @title = "Image size maximums"
    @height_limit = cookies[:height_max].nil? ? 600 : cookies[:height_max].to_i 
    @width_limit = cookies[:width_max].nil? ? 600 : cookies[:width_max].to_i 
  end
  
  def setprefs
    cookies[:height_max] = {
        :value => params[:height_max],
        :expires => 20.years.from_now.utc
    }
     cookies[:width_max] = {
        :value => params[:width_max],
        :expires => 20.years.from_now.utc
    }
    redirect_to session[:return_to]
  end
  
  private
  
    def reset_current_setname
      session[:current_setname] = ''
    end
    
    def store_calling_page
      session[:return_to] = request.fullpath
    end
    
end


