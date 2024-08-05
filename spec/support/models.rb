class User < Model
  validates :domain, :domain => true
end

class UserAllowsNil < Model
  validates :domain, :domain => {:allow_nil => true}
end

class UserAllowsNilFalse < Model
  validates :domain, :domain => {:allow_nil => false}
end

class UserAllowsBlank < Model
  validates :domain, :domain => {:allow_blank => true}
end

class UserAllowsBlankFalse < Model
  validates :domain, :domain => {:allow_blank => false}
end

class UserWithMessage < Model
  validates :domain, :domain => {:message => "isn't quite right"}
end

class UserVerifyDNS < Model
  validates :domain, :domain => {:verify_dns => true}
end

class UserVerifyDNSFalse < Model
  validates :domain, :domain => {:verify_dns => false}
end

class UserVerifyDNSMessage < Model
  validates :domain, :domain => {:verify_dns => {:message => "failed DNS check"}}
end

class UserVerifyExampleDotCom < Model
  validates :domain, :domain => {
    :verify_dns => {
      :same_ip_as => "example.com"
    }
  }
end

class UserVerifyExampleDotComWithMessage < Model
  validates :domain, :domain => {
    :verify_dns => {
      :same_ip_as => "example.com",
      :message => "failed DNS check"
    }
  }
end

class UserVerifyExampleDotComWithSpecificMessages < Model
  validates :domain, :domain => {
    :verify_dns => {
      :same_ip_as => "example.com",
      :incorrect_dns_record => "wrong ip",
      :missing_dns_record => "missing record"
    }
  }
end

class UserVerifyTxtRecord < Model
  validates :domain, :domain => {
      :verify_dns => {
        :verification_txt_record => {
          prefix: "_verification.",
          value: "d2adb9c6601a93b805e0dbd2638e084d"
        }
      }
    }
end

class UserVerifyTxtRecordFromCallable < Model
  attribute :txt_record, :string

  validates :domain, :domain => {
      :verify_dns => {
        :verification_txt_record => {
          prefix: "_verification.",
          value: ->(record) { record.txt_record }
        }
      }
    }
end

class UserVerifyTxtRecordWithMessage < Model
  validates :domain, :domain => {
      :verify_dns => {
        :verification_txt_record => {
          prefix: "_verification.",
          value: "d2adb9c6601a93b805e0dbd2638e084d"
        },
        :message => "failed DNS check"
      }
    }
end

class UserVerifyTxtRecordWithSpecificMessages < Model
  validates :domain, :domain => {
      :verify_dns => {
        :verification_txt_record => {
          prefix: "_verification.",
          value: "d2adb9c6601a93b805e0dbd2638e084d"
        },
        :missing_dns_record => "missing record",
        :missing_txt_record => "missing txt record"
      }
    }
end
