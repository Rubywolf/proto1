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
		redirect_to "/show/#{@pic.setname}/last"
	end
  
	def edit
		@pic=Pic.new
	end
	
	def show
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
    
    # Get the requested pic, set height to resize if necessary
		@pic=pics[@pic_num]
    if @pic.img_height.nil?
      size = FastImage.size(@pic.img_src, :timeout => 7)
      if !size.nil? 
        Pic.update(@pic.id, :img_width => size[0], :img_height => size[1])
        Pic.save(@pic.id)
      end
    end
    if @pic.img_height.nil?
      @pic_height = 450
    elsif @pic.img_height < 450
      @pic_height = @pic.img_height
    else
      @pic_height = 450
    end
	end
	
	def delete
		delete_pic = Pic.find(params[:pic_id])
		delete_pic.destroy
		new_num = params[:pic_num].to_i
    new_num -= 1
		redirect_to "/show/#{params[:set_name]}/#{new_num}"
	end
	
	def index
		@setnames= Pic.find( :all, :select => 'DISTINCT setname')
	end
		
	def last
		@pics = Pic.find_all_by_setname(params[:setname])
		redirect_to "/show/#{params[:setname]}/#{@pics.length-1}"
	end
	
end


