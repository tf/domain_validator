require "resolv"

module DomainValidator
  class DnsCheck
    def self.detect_issues(domain, options = {})
      Resolv::DNS.open do |dns|
        address = dns.getaddress(domain)

        if options[:same_ip_as]
          other_domain = options[:same_ip_as]
          other_domain = other_domain.call if other_domain.respond_to?(:call)
          other_address = dns.getaddress(other_domain)
          return :incorrect_dns_record if other_address != address
        end

        if options[:verification_txt_record]
          prefix = options[:verification_txt_record][:prefix]

          value = options[:verification_txt_record][:value]
          value = value.call(options[:context]) if value.respond_to?(:call)

          txt_records = dns.getresources("#{prefix}#{domain}.", Resolv::DNS::Resource::IN::TXT)
          strings = txt_records.flat_map(&:strings)

          return :missing_txt_record unless strings.include?(value)
        end

        return nil
      rescue Resolv::ResolvError => e
        return :missing_dns_record
      end
    end
  end
end
