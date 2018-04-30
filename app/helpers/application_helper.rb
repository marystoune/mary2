module ApplicationHelper



  def num_format(num)
    number_with_delimiter(num/100000000.0, :delimiter => ",")
  end

  def bin_to_hex(s)
    s.unpack('H*').first
  end

  def hex_to_bin(s)
    s.scan(/../).map { |x| x.hex }.pack('c*')
  end

  def header_menu_item(label, link)
    fullpath = request.fullpath.split("?").first
    
    attributes = {:class => "active"} if fullpath == link

    content_tag(:li, attributes) do
      out = link_to(label, link)
      out
    end
  end

  def include_related_asset(asset)
    if !Qiwicoin::Application.assets.find_asset(asset).nil?
      case asset.split('.')[-1]
        when 'js'
          javascript_include_tag asset, "data-turbolinks-track" => true
        when 'css'
          stylesheet_link_tag asset, media: "all", "data-turbolinks-track" => true
      end
    end
  end

	def title(page_title)
		content_for :title, page_title.to_s
	end

  def description(page_description)
    content_for :description, page_description.to_s
  end
end
