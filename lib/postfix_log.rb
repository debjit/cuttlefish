require 'file/tail'

module PostfixLog
  def self.tail
    # For the benefit of foreman
    $stdout.sync = true

    file = "/var/log/mail/mail.log"
    puts "Sucking up log entries in #{file}..."
    while true
      if File.exists?(file)
        File::Tail::Logfile.open(file) do |log|
          log.tail { |line| PostfixLogLine.create_from_line(line) }
        end
      else
        sleep(10)
      end
    end
  end

  def self.extract_postfix_queue_id_from_line(line)
    m = extract_main_content_postfix_log_line(line).match(/^\S+: (\S+):/)
    m[1] if m
  end

  def self.extract_time_from_postfix_log_line(line)
    parse_postfix_log_line(line).time
  end

  def self.extract_main_content_postfix_log_line(line)
    parse_postfix_log_line(line).content
  end

  private

  def self.parse_postfix_log_line(line)
    # Assume the log file was written using syslog and parse accordingly
    SyslogProtocol.parse("<13>" + line)
  end
end