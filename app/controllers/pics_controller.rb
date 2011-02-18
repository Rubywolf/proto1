class PicsController < ApplicationController
  require 'fastimage'
  
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
		@pic=Pic.new
	end
	
	def show
    @height_limit = 700
    # Get the pics in the requested set
    this_set = params[:setname]
		pics=Pic.find_all_by_setname(this_set)
    @pics_count = pics.length
    
    # If there are no pics in the set, use all pics in database
		if @pics_count == 0
			pics=Pic.find(:all)
      @pics_count = pics.length
      @pic_num = 0
 	    @route_string="/show"
    else
      @pic_num = params[:id].to_i
      @route_string="/show/#{this_set}"
		end
    
    # Get the requested pic, resize if too large
		@pic=pics[@pic_num]
    if @pic.img_height < @height_limit
      @pic_height = @pic.img_height
    else
      @pic_height =@height_limit
    end
	end
	
	def delete
		delete_pic = Pic.find(params[:pic_id])
		delete_pic.destroy
		new_num = params[:pic_num].to_i
    new_num -= 1
    if new_num < 0 
      set_count = Pic.find_all_by_setname(params[:set_name]).length
      if set_count > 0
        redirect_to "/show/#{params[:set_name]}/0"
      else
        redirect_to "/"
      end
    else
      redirect_to "/show/#{params[:set_name]}/#{new_num}"
    end
	end
	
	def index
		@setnames= Pic.find( :all, :select => 'DISTINCT setname')
	end
		
	def last
		@pics = Pic.find_all_by_setname(params[:setname])
		redirect_to "/show/#{params[:setname]}/#{@pics.length-1}"
	end
	
end


