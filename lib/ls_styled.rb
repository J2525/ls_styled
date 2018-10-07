require "ls_styled/version"

module LsStyled
  def self.run(path, opts = {})
    files = self.get_files(path, opts)
    return self.l_option(files) if opts[:l]
    puts files
  end

  def self.get_files(path, opts = {})
    lists = opts[:r] ? Dir::entries(path).sort.reverse : Dir::entries(path).sort

    return lists if opts[:a]

    results = []
    lists.each do |list|
      next if list[0] == '.'
      results << list
    end
    results
  end

  def self.l_option(files)
    files.each do |file|
      stat = File.stat(file)
      results = [
        stat.dev,
        stat.mode,
        stat.nlink,
        Etc.getpwuid(stat.uid).name,
        Etc.getgrgid(stat.gid).name,
        stat.size,
        stat.mtime,
        file
      ]
      puts results.join(" ")
    end
  end
end
