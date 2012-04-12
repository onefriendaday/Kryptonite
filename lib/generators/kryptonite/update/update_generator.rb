module Kryptonite
  class UpdateGenerator < Rails::Generators::Base
    
      source_root File.expand_path('../templates', __FILE__)
      
      def generate_files
        puts "*** Updating Kryptonite public assets. These should not be modified as they may be overwritten in future updates. ***"

        #stylesheets
  			copy_file "public/kryptonite/stylesheets/screen.css", "public/kryptonite/stylesheets/screen.css"
  			copy_file "public/kryptonite/stylesheets/elements.css", "public/kryptonite/stylesheets/elements.css"
  			copy_file "public/kryptonite/stylesheets/login.css", "public/kryptonite/stylesheets/login.css"
  			copy_file "public/kryptonite/stylesheets/fileuploader.css", "public/kryptonite/stylesheets/fileuploader.css"

  			#javascripts
  			copy_file "public/kryptonite/javascripts/kryptonite.js", "public/kryptonite/javascripts/kryptonite.js"
  			copy_file "public/kryptonite/javascripts/login.js", "public/kryptonite/javascripts/login.js"
  			copy_file "public/kryptonite/javascripts/jquery.js", "public/kryptonite/javascripts/jquery.js"
  			copy_file "public/kryptonite/javascripts/rails.js", "public/kryptonite/javascripts/rails.js"
  			copy_file "public/kryptonite/javascripts/fileuploader.js", "public/kryptonite/javascripts/fileuploader.js"

        #images
        copy_file "public/kryptonite/images/header.png", "public/kryptonite/images/header.png"
        copy_file "public/kryptonite/images/nav.png", "public/kryptonite/images/nav.png"
        copy_file "public/kryptonite/images/rightNav.png", "public/kryptonite/images/rightNav.png"
        copy_file "public/kryptonite/images/rightNavButton.png", "public/kryptonite/images/rightNavButton.png"
        copy_file "public/kryptonite/images/kryptonite.png", "public/kryptonite/images/kryptonite.png"
        copy_file "public/kryptonite/images/visitSiteNav.png", "public/kryptonite/images/visitSiteNav.png"
  			copy_file "public/kryptonite/images/login/top.png", "public/kryptonite/images/login/top.png"
  		  copy_file "public/kryptonite/images/login/bottom.png", "public/kryptonite/images/login/bottom.png"
  		  copy_file "public/kryptonite/images/loading.gif", "public/kryptonite/images/loading.gif"

  			#icons
  			all_icons = Dir.new(File.expand_path('../templates/public/kryptonite/images/icons/', __FILE__)).entries

  			for icon in all_icons
  				if File.extname(icon) == ".png"
  					copy_file "public/kryptonite/images/icons/#{icon}", "public/kryptonite/images/icons/#{icon}"
  				end
  			end
  		end
  end
end