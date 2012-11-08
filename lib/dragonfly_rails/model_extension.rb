module DragonflyRails
  module CustomPathExtension
    TO_BE_MIGRATE=true
    PATH_STYLES = [:id_partition, :time_partition, :cache_partition]
    def path_style=(style)
      check_path_style(style)
      @path_style = style
    end
    def path_style
      @path_style ||= :id_partition
    end
    def create_dragonfly_uid(df_uid_field, paperclip_accessor, options = {})
      path = new_dagronfly_path(df_uid_field, paperclip_accessor, options)
      if send(df_uid_field).nil? && path
        update_attribute(df_uid_field, generate_path(path))
      end
    end
    def update_dragonfly_uid(df_uid_field, paperclip_accessor, options = {})
      current_path = send(df_uid_field)
      path = new_dagronfly_path(df_uid_field, paperclip_accessor, options)
      update_attribute(df_uid_field, generate_path(path)) if generate_path(path) != current_path
    end
    def new_dagronfly_path(df_uid_field, paperclip_accessor, options = {})
      options = {:original_size => :original}.merge(options)
      send(paperclip_accessor).path(options[:original_size])
    end
    def generate_path(path)
	    final_path = case path_style
					when :id_partition
						path[ %r{\w{1,}\/(\d{3}\/){3}.*} ]
					when :cache_partition
						path.gsub(Rails.root.to_s << "/uploads/", "") if path
					when :time_partition
						raise "what now? not my business, need no :time_partition"
	    end
	    #puts "generated final_path: #{final_path.inspect}"
	    final_path
    end

	  private

	  def raise_invalid_path_style(style)
		  raise "Unknown path_style: #{style}"
	  end

	  def check_path_style(style)
		  raise_invalid_path_style(style) unless  PATH_STYLES.include?(style)
	  end
  end
end