class PicsController < ApplicationController
  require 'fastimage'
  before_filter :store_calling_page, :only => [:show,  :new, :index, :slideshow]
  after_filter :reset_current_setname, :except => [:show, :slideshow, :new_slide] 
  
	def index
    @title = "Choose a picture set"
		@setnames= Pic.find( :all, :select => 'DISTINCT setname', :order => 'setname')
    @setnames.delete("chicks")
	end
		
	def new
    @title = "Add a new image..."
		@pic=Pic.new
    @pic.setname = session[:current_setname]
	end
	
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
    @pic_height = fitted_height @pic
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
	
	def last
		@pics = Pic.find_all_by_setname(params[:setname])
		redirect_to "/show/#{params[:setname]}/#{@pics.count-1}"
	end
  
  def getprefs
    @title = "Image size maximums"
    @height_limit = cookies[:height_max].nil? ? 600 : cookies[:height_max].to_i 
    @width_limit = cookies[:width_max].nil? ? 600 : cookies[:width_max].to_i 
    @slide_time = cookies[:slide_time].nil? ? 5 : cookies[:slide_time].to_i 
    @seq = cookies[:slide_seq].nil? ? "sequential" : cookies[:slide_seq]
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
    cookies[:slide_time] = {
        :value => params[:slide_time],
        :expires => 20.years.from_now.utc
    }
    cookies[:slide_seq] = {
        :value => params[:seq],
        :expires => 20.years.from_now.utc
    }
    redirect_to session[:return_to]
  end
  
  def slideshow
    @title = "Slideshow"
    pic_set = Pic.find_all_by_setname(params[:setname], :order => "created_at")
    #~ @image_num = rand(pic_set.count)
    @image_num = params[:pic_num].to_i
    session[:pic_num] = @image_num
    @slide_pic = pic_set[@image_num]
    @fit_height = fitted_height @slide_pic
    @slide_time = cookies[:slide_time].nil? ? 5 : cookies[:slide_time].to_i 
  end
  
  def new_slide 
    pic_set = Pic.find_all_by_setname(params[:setname], :order => "created_at")
    slideshow_type = cookies[:slide_seq].nil? ? "sequential" : cookies[:slide_seq]
    if slideshow_type == "random"
      @image_num = rand(pic_set.count)
    else
      @image_num = session[:pic_num].to_i
      @image_num += 1
      @image_num = 0 if @image_num == pic_set.count
      session[:pic_num] = @image_num
    end
    @slide_pic = pic_set[@image_num]
    @fit_height = fitted_height @slide_pic
    render :inline => "<%= link_to(image_tag('stop.png'), '/show/#{@slide_pic.setname}/#{@image_num}') %><br\>" \
                      "<%= image_tag @slide_pic.img_src, :height => @fit_height %>"

  end
  
  def backup
    @mypics = Pic.find(:all)
  end
  
  private
  
    def reset_current_setname
      session[:current_setname] = ''
    end
    
    def store_calling_page
      session[:return_to] = request.fullpath
    end
    
    def fitted_height(this_pic)
      # adjust height to fit
      height_limit = cookies[:height_max].nil? ? 600 : cookies[:height_max].to_i 
      width_limit = cookies[:width_max].nil? ? 600 : cookies[:width_max].to_i 
      height_ratio = this_pic.img_height.to_f / height_limit.to_f
      width_ratio = this_pic.img_width.to_f / width_limit.to_f
      ratio = height_ratio > width_ratio ? height_ratio : width_ratio
      ratio = ratio > 1 ? ratio : 1
      pic_height = this_pic.img_height.to_f / ratio
      pic_height.to_i
    end
      
end


