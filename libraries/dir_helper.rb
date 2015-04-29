module DirHelper
  def self.expand(watch_files)
    watch_files.inject({}) do |memo, (filename, tag)|
      if filename[/\*/]
        Dir.glob(filename).each { |f| memo[f] = tag }
      else
        memo[filename] = tag
      end
      memo
    end
  end
end
