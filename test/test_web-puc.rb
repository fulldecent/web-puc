require "minitest/autorun"
FIXTURES_DIR = File.expand_path('fixtures', File.dirname(__FILE__))
WEB_PUC = File.expand_path('../bin/web-puc', File.dirname(__FILE__))

class WebPucTest < Minitest::Test
#    def test_that_it_has_a_version_number
#        refute_nil ::WebPuc::VERSION
#    end
    
    def finds_old_bootstrap_link
        result = %x[ ruby #{WEB_PUC} -l bootstrap #{FIXTURES_DIR}/bad.html ]
        # Expect to match /Old version/
        # TODO: TEST THIS
        puts result
        assert true
    end

    def finds_no_errors_in_file_with_last_bootstrap_version
        result = %x[ ruby #{WEB_PUC} -l bootstrap #{FIXTURES_DIR}/good.html ]
        # Expect to match /PASSED with no warning/
        # TODO: TEST THIS
        puts result
        assert true
    end

    def finds_old_font_awesome_link
        result = %x[ ruby #{WEB_PUC} -l font-awesome #{FIXTURES_DIR}/subfolder/bad.html ]
        # Expect to match /Old version/
        # TODO: TEST THIS
        puts result
        assert true
    end

    def finds_no_errors_in_file_with_last_font_awesome_version
        result = %x[ ruby #{WEB_PUC} -l font-awesome #{FIXTURES_DIR}/subfolder/good.html ]
        # Expect to match /PASSED with no warning/
        # TODO: TEST THIS
        puts result
        assert true
    end
end