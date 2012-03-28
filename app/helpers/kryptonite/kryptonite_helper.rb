module Kryptonite
  module KryptoniteHelper
	
	  def kryptonite_get_version_info  
	    YAML::load_file File.join(File.dirname(__FILE__), '..', '..', '..', 'PUBLIC_VERSION.yml')
	  end
	
  	def kryptonite_get_full_version_string
  	  version_info = kryptonite_get_version_info
  	  "v.#{version_info['major']}.#{version_info['minor']}.#{version_info['patch']}"
  	end
	
  	def kryptonite_get_short_version_string
  	  version_info = kryptonite_get_version_info
  	  "v.#{version_info['major']}"
  	end
	
  	def kryptonite_generate_page_title
		
  		if @kryptonite_page_title.nil?
  			return kryptonite_config_website_name
  		end
		
  		@kryptonite_page_title + " > " + kryptonite_config_website_name
  	end
	
  	def kryptonite_get_access_level_text level
  	  case level
        when $KRYPTONITE_USER_ACCESS_LEVEL_ADMIN
          return "Administrator"
        when $KRYPTONITE_USER_ACCESS_LEVEL_USER
  	      return "User"
  	    else
  	      return "Unknown"
  	  end
  	end
	
  	def kryptonite_get_access_level_array
  	  [["Administrator", $KRYPTONITE_USER_ACCESS_LEVEL_ADMIN], ["User", $KRYPTONITE_USER_ACCESS_LEVEL_USER]]
  	end
	
  	def kryptonite_table_cell_link contents, link, options = {}
	  
  	  if options.key? :kryptonite_truncate
  	    contents = truncate(contents, :length => options[:kryptonite_truncate], :omission => "...")
  	  end
	  
    	link_to "#{contents}".html_safe, link, options
    end
    
    def kryptonite_table_cell_no_link contents, options = {}
	  
  	  if options.key? :kryptonite_truncate
  	    contents = truncate(contents, :length => options[:kryptonite_truncate], :omission => "...")
  	  end
	  
    	"<div class='noLink'>#{contents}</div>".html_safe
    end
	
  	def kryptonite_show_icon icon_name
  		"<div class='icon'><img src='/kryptonite/images/icons/#{icon_name}.png' alt='' /></div>".html_safe
  	end
	
  	def kryptonite_show_row_icon icon_name
  		"<div class='iconRow'><img src='/kryptonite/images/icons/#{icon_name}.png' alt='' /></div>".html_safe
  	end
	
  	# Styled form tag helpers
	
  	def kryptonite_text_field form, obj, attribute, options = {}
  	  kryptonite_form_tag_wrapper(form.text_field(attribute, strip_kryptonite_options(options_hash_with_merged_classes(options, 'kryptoniteTextField'))), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_password_field form, obj, attribute, options = {}
  		kryptonite_form_tag_wrapper(form.password_field(attribute, strip_kryptonite_options(options_hash_with_merged_classes(options, 'kryptoniteTextField'))), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_text_area form, obj, attribute, options = {}
  	  kryptonite_form_tag_wrapper(form.text_area(attribute, strip_kryptonite_options(options_hash_with_merged_classes(options, 'kryptoniteTextArea'))), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_text_area_big form, obj, attribute, options = {}
  	 kryptonite_form_tag_wrapper(form.text_area(attribute, strip_kryptonite_options(options_hash_with_merged_classes(options, 'kryptoniteTextAreaBig'))), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_check_box form, obj, attribute, options = {}
  	  form_tag = form.check_box(attribute, strip_kryptonite_options(options))
	  
  	  if options.key? :kryptonite_box_label
  	    form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:kryptonite_box_label]}</span></div>".html_safe
  	  end
	  
  	  kryptonite_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_check_box_group form, obj, check_boxes = {}
      form_tags = ""
    
      for check_box in check_boxes
        form_tags += kryptonite_check_box form, obj, check_box[0], check_box[1]
      end
    
      kryptonite_form_tag_wrapper form_tag, form, obj, attribute, options
    end
	
  	def kryptonite_radio_button form, obj, attribute, tag_value, options = {}
  	  form_tag = form.radio_button(obj, attribute, tag_value, strip_kryptonite_options(options))
	  
  	  if options.key? :kryptonite_button_label
  	    form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:kryptonite_button_label]}</span></div>".html_safe
  	  end
	  
  	  kryptonite_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_radio_button_group form, obj, radio_buttons = {}
      form_tags = ""
    
      for radio_button in radio_buttons
        form_tags += kryptonite_radio_button form, obj, check_box[0], check_box[1], check_box[2]
      end
    
      kryptonite_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
    end
	
  	def kryptonite_select form, obj, attribute, option_tags, options = {}
  		kryptonite_form_tag_wrapper(form.select(attribute, option_tags, strip_kryptonite_options(options), merged_class_hash(options, 'kryptoniteSelect')), form, obj, attribute, options).html_safe
  	end
  	
  	def kryptonite_time_zone_select form, obj, attribute, option_tags, options = {}
  	  kryptonite_form_tag_wrapper(form.time_zone_select(attribute, option_tags, strip_kryptonite_options(options), merged_class_hash(options, 'kryptoniteSelect')), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_collection_select form, obj, object, attribute, collection, value_method, text_method, options = {}
  		kryptonite_form_tag_wrapper(collection_select(object, attribute, collection, value_method, text_method, strip_kryptonite_options(options), merged_class_hash(options, 'kryptoniteSelect')), form, obj, attribute, options).html_safe
  	end
  	
  	def kryptonite_date_select form, obj, attribute, options = {}
  	  kryptonite_form_tag_wrapper(form.date_select(attribute, strip_kryptonite_options(options), merged_class_hash(options, 'kryptoniteDateTimeSelect')), form, obj, attribute, options).html_safe
  	end

  	def kryptonite_time_select form, obj, attribute, options = {}
  	  kryptonite_form_tag_wrapper(form.time_select(attribute, strip_kryptonite_options(options), merged_class_hash(options, 'kryptoniteDateTimeSelect')), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_datetime_select form, obj, attribute, options = {}
  	  kryptonite_form_tag_wrapper(form.datetime_select(attribute, strip_kryptonite_options(options), merged_class_hash(options, 'kryptoniteDateTimeSelect')), form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_file_field form, obj, object_name, attribute, options = {}
  	  class_hash = merged_class_hash(options, 'kryptoniteFileFieldContainer')
  	  contents = "<div class='#{class_hash[:class]}'>" + file_field(object_name, attribute, strip_kryptonite_options(options)) + '</div>'
  	  kryptonite_form_tag_wrapper(contents, form, obj, attribute, options).html_safe
  	end
	
  	def kryptonite_hidden_field form, obj, attribute, options = {}
  	  form.hidden_field(attribute, strip_kryptonite_options(options)).html_safe
  	end
	
  protected

    def strip_kryptonite_options options
      options.reject {|key, value| key.to_s.include? "kryptonite_" }
    end
    
    def merged_class_hash options, new_class
      if options.key? :class
        new_class += " #{options[:class]}"
      end
        
      {:class => new_class}
    end
    
    def options_hash_with_merged_classes options, new_class
      if options.key? :class
        new_class += " #{options[:class]}"
      end
      options[:class] = new_class
      options
    end

    def kryptonite_form_tag_wrapper form_tag, form, obj, attribute, options = {}
        unless options.key? :kryptonite_label
    		  human_attribute_name = attribute.to_s.humanize
        else
          human_attribute_name = options[:kryptonite_label]
        end

    		html = "<p>"

        if obj && obj.errors[attribute].any?
    			html += "<span class='formError'>#{human_attribute_name} #{obj.errors[attribute].first}</span>".html_safe
    		else
    			html += form.label(attribute, human_attribute_name)
    		end

    		html += "</p>\n<p>#{form_tag}</p>"
    end
  end
end