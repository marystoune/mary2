module BlocksHelper

  def block_height_link(block)
    link_to block.block_height, block_detail_path(block.block_height)
  end

  def block_hash_link(block)
    link_to bin_to_hex(block.block_hash), block_detail_path(block.block_height)
  end
  
end
