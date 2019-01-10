# TODO we can probably remove this. Need to figure out what we're using for uploads again.

Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'