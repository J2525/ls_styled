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
      stat = File.lstat(file)
      permission = self.get_file_type("0%o" % stat.mode).push(self.get_permission("0%o" % stat.mode))
      results = [
        permission.join(""),
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

  def self.get_file_type(mode)
    results  = []
    file_type = mode[0..-4]
    results << "l" if file_type == "0120"
    results << "-" if file_type == "0100"
    results << "d" if file_type == "040"
    return results
  end

  def self.get_permission(mode)
    results = []
    permissions = []
    permissions << mode[-3]
    permissions << mode[-2]
    permissions << mode[-1]

    permissions.each do |permission|
      results << "---" if permission == "0"
      results << "--x" if permission == "1"
      results << "-w-" if permission == "2"
      results << "-wx" if permission == "3"
      results << "r--" if permission == "4"
      results << "r-x" if permission == "5"
      results << "rw-" if permission == "6"
      results << "rwx" if permission == "7"
    end

    return results.join("")

  end
end
