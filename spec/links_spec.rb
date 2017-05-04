require 'rspec'
FIXTURES_DIR = File.expand_path('fixtures', File.dirname(__FILE__))
WEB_BUC = File.expand_path('../bin/web-puc', File.dirname(__FILE__))

describe 'Links test' do

  it 'finds old bootstrap link' do
    bad_html = %x[ ruby #{WEB_BUC} --stat #{FIXTURES_DIR}/bad.html ]
    expect(bad_html).to match(/"failure": true/)
  end

  it 'finds no errors in file with last bootstrap version' do
    bad_html = %x[ ruby #{WEB_BUC} --stat #{FIXTURES_DIR}/good.html ]
    expect(bad_html).to match(/"findings": \[\n\n {2}\]/)
  end

  it 'finds old font-awesome link' do
    bad_html = %x[ ruby #{WEB_BUC} --stat #{FIXTURES_DIR}/subfolder/bad.html ]
    expect(bad_html).to match(/"failure": true/)
  end

  it 'finds no errors in file with last font-awesome version' do
    bad_html = %x[ ruby #{WEB_BUC} --stat #{FIXTURES_DIR}/subfolder/good.html ]
    expect(bad_html).to match(/"findings": \[\n\n {2}\]/)
  end
end