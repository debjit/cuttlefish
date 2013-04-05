require "spec_helper"

describe PostfixLog do
  let(:line1) { "Apr  5 16:41:54 kedumba postfix/smtp[18733]: 39D9336AFA81: to=<foo@bar.com>, relay=foo.bar.com[1.2.3.4]:25, delay=92780, delays=92777/0.03/1.6/0.91, dsn=4.3.0, status=deferred (host foo.bar.com[1.2.3.4] said: 451 4.3.0 <bounces@planningalerts.org.au>: Temporary lookup failure (in reply to RCPT TO command))" }
  let(:line2) { "Apr  5 18:41:58 kedumba postfix/qmgr[2638]: E69DB36D4A2B: removed" }
  let(:line3) { "Apr  5 17:11:07 kedumba postfix/smtpd[7453]: connect from unknown[111.142.251.143]" }
  let(:line4) { "Apr  5 14:21:51 kedumba postfix/qmgr[2638]: 39D9336AFA81: from=<bounces@planningalerts.org.au>, size=7577, nrcpt=1 (queue active)" }

  describe ".extract_postfix_queue_id_from_line" do
    it { PostfixLog.extract_postfix_queue_id_from_line(line1).should == "39D9336AFA81" }
    it { PostfixLog.extract_postfix_queue_id_from_line(line2).should == "E69DB36D4A2B" }
    it { PostfixLog.extract_postfix_queue_id_from_line(line3).should be_nil }
  end

  describe ".extract_time_from_postfix_log_line" do
    it { PostfixLog.extract_time_from_postfix_log_line(line1).should == Time.local(2013,4,5,16,41,54) }
    it { PostfixLog.extract_time_from_postfix_log_line(line2).should == Time.local(2013,4,5,18,41,58) }
  end
end