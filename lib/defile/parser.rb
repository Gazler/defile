module Defile
  class Parser

    def self.comment_char(file)
      @types ||= {
        "hs" => "--"
      }
      @types[file.split(".").last] || "#"
    end


    def self.parse
      Dir.glob("{*,.*}").each do |file|
        next if Constants::IGNORE_FILES.include?(file.split("/").last)
        next if file.include?(".swp")
        parse_file(file)
      end
    end

    def self.parse_file(file)
      output = []
      instruction = nil
      comment = comment_char(file)

      File.readlines(file).each do |line|

        #We want to reset instruction for the next loop
        instr , instruction = instruction, nil
        case instr
        when "ignore" 
          next
        when "private"
          #Turn the line into a comment
          line.insert(0, comment)
          line = line.split("=")
          line[1]="{{DEFILE private}}\n"
          line = line.join("=")
        end

        if line.start_with?("#{comment}DEFILE ")
          instruction = line.gsub(/#{comment}DEFILE /, "").chomp
          next
        end

        output << line

      end

      save_file(output, file)
    end

    def self.save_file(contents, file)
      saved_file = File.new("backup/#{file}", "w")
      saved_file.write(contents.join(""))
      saved_file.close
    end
  end
end
