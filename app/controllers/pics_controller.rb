class PicsController < ApplicationController
	def save
		@pic=Pic.new(params[:pic])
		@pic.save
		redirect_to "/show/#{@pic.setname}/last"
	end
	def edit
		@pic=Pic.new
	end
	def show
		@pics=Pic.find_all_by_setname(params[:setname])
		if @pics.length == 0
			@pics=Pic.find(:all)
		end
		@pic_num = params[:id].to_i
		@pic=@pics[@pic_num]
		@route_string="/show/#{@pic.setname}"
	end
	
	def delete
		delete_pic = Pic.find(params[:pic_id])
		delete_pic.destroy
		new_num = params[:pic_num].to_i -1
		redirect_to "/show/#{params[:set_name]}/#{new_num}"
	end
	
	def index
		#@setname= Pic.find( :all, :select => 'DISTINCT caption')
		@setnames= Pic.find( :all, :group => :setname)
		@name1 = @setnames[0]
		@name2 = @setnames[1]
		@name3 = @setnames[2]
		@dogs_string = "dog"
	end
		
	def last
		@pics = Pic.find_all_by_setname(params[:setname])
		redirect_to "/show/#{params[:setname]}/#{@pics.length-1}"
	end
	
end


