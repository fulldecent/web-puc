require 'rspec'
FIXTURES_DIR = File.expand_path('fixtures', File.dirname(__FILE__))
WEB_PUC = File.expand_path('../bin/web-puc', File.dirname(__FILE__))

describe 'Links test' do

  it 'finds old bootstrap link' do
    bad_html = %x[ ruby #{WEB_PUC} -l twitter-bootstrap #{FIXTURES_DIR}/bad.html ]
    expect(bad_html).to match(/Old version/)
  end

  it 'finds no errors in file with last bootstrap version' do
    bad_html = %x[ ruby #{WEB_PUC} -l twitter-bootstrap #{FIXTURES_DIR}/good.html ]
    expect(bad_html).to match(/PASSED with no warning/)
  end

  it 'finds old font-awesome link' do
    bad_html = %x[ ruby #{WEB_PUC} -l font-awesome #{FIXTURES_DIR}/subfolder/bad.html ]
    expect(bad_html).to match(/Old version/)
  end

  it 'finds no errors in file with last font-awesome version' do
    bad_html = %x[ ruby #{WEB_PUC} -l font-awesome #{FIXTURES_DIR}/subfolder/good.html ]
    expect(bad_html).to match(/PASSED with no warning/)
  end
end
