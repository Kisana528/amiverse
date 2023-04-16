class WellKnownController < ApplicationController
  def host_meta
    render xml: <<~XML.strip_heredoc
      <?xml version="1.0" encoding="UTF-8"?>
      <XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
        <Link rel="lrdd" type="application/xrd+xml" template="https://api.amiverse.net/.well-known/webfinger?resource={uri}" />
      </XRD>
    XML
  end
  def webfinger
  resource = params[:resource]
  if resource.start_with?("acct:")
    resource = resource[5..-1]
  end
    if resource.include?('@')
      parts = resource.split('@')
      if parts.length == 3 #~@~@~
        domain = parts.pop
        name_id = parts.pop
      elsif parts.length == 2 #~@~
        if resource.start_with?('@')
          name_id = parts[1]
          domain = ''
        else
          name_id = parts[0]
          domain = parts[1]
        end
      elsif parts.length == 1 #~@
        name_id = parts[0]
        domain = ''
      end
    else
      name_id = resource
      domain = ''
    end
    if domain.blank? || domain == 'amiverse.net' || domain == 'api.amiverse.net'
      if Account.exists?(name_id: name_id)
        render json: {
          subject: "acct:#{name_id}@amiverse.net",
          links: [{
            rel: "self",
            type: "application/activity+json",
            href: "https://api.amiverse.net/v1/@#{name_id}"
          }]
        }
      else
        render status: 400, json: {}
      end
    else
      render status: 400, json: {}
    end
  end
end