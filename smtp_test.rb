require 'net/smtp'

# メールの内容
message = <<MESSAGE_END
From: Private Person <#{ENV['GMAIL_USERNAME']}>
To: A Test User <nba20093089@gmail.com>
Subject: SMTP e-mail test

This is a test e-mail message.
MESSAGE_END

begin
  smtp = Net::SMTP.new('smtp.gmail.com', 587)
  smtp.enable_starttls

  smtp.start('gmail.com', ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'], :plain) do |smtp|
    smtp.send_message message, ENV['GMAIL_USERNAME'], 'nba20093089@gmail.com'
  end
  puts "Email sent successfully"
rescue => e
  puts "Failed to send email: #{e.message}"
end
