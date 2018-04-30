class SearchController < ApplicationController
	def search
		search = Search.new(params[:srch_condition])
		path = search.result
		
		flash[:alert] = "Sorry incorrect request" if path == root_path
		redirect_to path
	end
end
