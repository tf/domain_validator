require "active_model"
require "active_model/validator"

module DomainValidator
  class Validator < ActiveModel::EachValidator

    RE_DOMAIN = %r(^(?=.{1,255}$)[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?(?:\.[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?)+$)

    DEFAULT_MESSAGES = {
      :invalid_domain => "is invalid",
      :invalid_dns_record => "does not have a valid DNS record"
    }

    def validate_each(record, attr_name, value)
      validate_domain_format(record, attr_name, value)
      # Only perform DNS check if domain is a valid format
      validate_domain_dns(record, attr_name, value) if record.errors.empty? && options[:verify_dns]
    end

    def validate_domain_format(record, attr_name, value)
      unless is_valid_domain?(value)
        record.errors.add(attr_name, :invalid_domain, message: invalid_domain_message)
      end
    end

    def validate_domain_dns(record, attr_name, value)
      issue = detect_dns_issues(record, value)
      record.errors.add(attr_name, issue, message: dns_message(issue)) if issue
    end

    def is_valid_domain?(domain)
      domain =~ RE_DOMAIN
    end

    def detect_dns_issues(record, domain)
      dns_options = options[:verify_dns].is_a?(Hash) ? options[:verify_dns] : {}
      options[:verify_dns] ? DnsCheck.detect_issues(domain, {context: record, **dns_options}) : nil
    end

    def invalid_domain_message
      options[:message] || DEFAULT_MESSAGES[:invalid_domain]
    end

    def dns_message(issue)
      custom_dns_message(issue) || DEFAULT_MESSAGES[:invalid_dns_record]
    end

    def custom_dns_message(issue)
      verify_dns = options[:verify_dns]
      if verify_dns.is_a? Hash
        verify_dns[issue] || verify_dns[:message]
      end
    end

  end
end

ActiveModel::Validations::DomainValidator = DomainValidator::Validator
