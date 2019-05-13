require 'fileutils'

Dir.glob(File.expand_path("../{ChouTi\ Example\ iOS\ UITests,ChouTi\ Example\ iOS,Source,Tests}/**/*.{h,swift}")).each do |file_path|
	puts "Process #{file_path}"
	lines = File.open(file_path, "rb").readlines
	updated_lines = lines.map do |line|
		if line =~ /ChouTi\. All rights reserved./
			"//  Copyright © #{Time.new.year} ChouTi. All rights reserved."
		else
			line
		end
	end
	
	File.open(file_path, "w") { |file| 
		file.puts updated_lines
	}
end
