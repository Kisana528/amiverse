module ActivityPub
  def create_note(item)
    {
      "@context": "https://www.w3.org/ns/activitystreams",
      "type": "Create",
      "id": "https://amiverse.net/items/#{item.item_id}/create",
      "published": item.created_at,
      "to": [
        "https://amiverse.net/#{item.account.name_id}/followers",
        "https://www.w3.org/ns/activitystreams#Public"
      ],
      "actor": "https://amiverse.net/#{item.account.name_id}",
      "object": {
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Note",
        "id": "https://amiverse.net/items/#{item.item_id}",
        "url": "https://amiverse.net/items/#{item.item_id}",
        "published": item.created_at,
        "to": [
          "https://amiverse.net/#{item.account.name_id}/followers",
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "attributedTo": "https://amiverse.net/#{item.account.name_id}/followers",
        "content": item.content
      }
    }
  end
  def deliver(body, private_key, name_id, host='mstdn.jp', path='/inbox')
    current_time = Time.now
    formatted_time = current_time.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
    digest = Digest::SHA256.base64digest(body.to_s) #hexdigest?
    to_be_signed = "(request-target): post /inbox\nhost: #{host}\ndate: #{formatted_time}\ndigest: sha-256=#{digest}"
    sign = generate_signature(to_be_signed, private_key)
    signature = 'keyId="https://amiverse.net/@' + name_id + '#main-key",algorithm="rsa-sha256",headers="(request-target) host date digest",signature="' + sign + '"'
    req,res = http_post(
      #'https://' + host + '/inbox',
      'http://front:3000/@kisana/inbox',
      { 'Content-Type' => 'application/activity+json',
        'Host' => host,
        'Date' => formatted_time,
        'Digest' => 'SHA-256=' + digest,
        'Signature' => signature
      },
      body.to_json
    )
    Rails.logger.info('ok')
  end
end