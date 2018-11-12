require 'fileutils'

Dir.glob(File.expand_path("**/*.swift")).each do |file_path|
	lines = File.open(file_path, "rb").readlines
	if lines[1] =~ /.*?.swift/
		puts "Process #{file_path}"
		lines = lines[3..-1]

		updated_lines = lines.map do |line|
			if line =~ /Created by (.*?) on (\d{4})-(\d{2})-(\d{2})./i
				new_date = "#{$3}/#{$4}/#{$2}"
				# return line.g "Created by #{$1} on #{new_date}."
				# line.gsub(/Created by (.*?) on (\d{4})-(\d{2})-(\d{2})./, )
				"//  Created by Honghao Zhang on #{new_date}."
			else
				line
			end
		end
		
		File.open(file_path, "w") { |file| 
			file.puts updated_lines
		}
	end
end
