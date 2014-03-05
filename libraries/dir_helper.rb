module DirHelper
  def self.expand(watch_files)
    watch_files.inject({}) do |memo, (filename, tag)|
      Dir.glob(filename).each { |f| memo[f] = tag }
      memo
    end
  end
end
